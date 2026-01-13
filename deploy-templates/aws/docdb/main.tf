provider "aws" {
  region  = local.environment.source_region
  profile = ""
}

resource "aws_docdb_cluster_parameter_group" "docdbclusterparamgp" {
  name   = "${local.environment.app_name_instance}-paramgp"
  family = "docdb5.0"

  parameter {
    name         = "tls"
    value        = "enabled"
    apply_method = "pending-reboot"
  }

}


# Module used to create the necessary KMS key. Make sure your path for the source reflects your directory position
module "kmskey" {
  source        = "../../../../terraform-modules/kms/dbakmskeys"
  name          = local.environment.name
  environment   = local.environment.environment
  account       = local.environment.account
  required_tags = local.environment.required_tags
  resource_tags = local.environment.resource_tags
}

# Module used to create the docdb cluster. Make sure your path for the source reflects your directory position
module "docdb" {
  source              = "../../../../terraform-modules/db/documentdb/docdb"
  environment         = local.environment.environment
  database_name       = local.environment.database_name
  docdbsecuritygp     = local.environment.docdbsecuritygp
  number_of_instances = local.environment.number_of_instances
  parameter_group     = aws_docdb_cluster_parameter_group.docdbclusterparamgp.name
  kms_key_arn         = module.kmskey.key_arn
  deletion_protection = local.environment.deletion_protection
  maintenance_window  = local.environment.maintenance_window
  required_tags       = local.environment.required_tags
  resource_tags       = local.environment.resource_tags

  depends_on = [module.kmskey.key_arn]
}

# Outputs info on app name after deploy
output "account" {
  value = module.docdb.account
}

# Outputs info on docdb cluster endpoint after deploy. As of 2025-03-17, AWS DocDB does not support the use of Route53 dns records
output "docdb_endpoint" {
  value = module.docdb.endpoint
}
