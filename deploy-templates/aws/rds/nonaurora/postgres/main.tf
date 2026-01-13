

provider "aws" {
  region  = local.environment.source_region
  profile = "profile-name"
}

# Module used to create the necessary KMS key. Make sure your path for the source reflects your directory position.
module "kmskey" {
  source        = "../../../../../terraform-modules/kms/dbakmskeys"
  name          = local.environment.service
  environment   = local.environment.environment
  account       = data.aws_caller_identity.current.account_id
  required_tags = local.environment.required_tags
  resource_tags = local.environment.resource_tags
}


# Module used to create the rds instance.
module "nonaurora" {
  source              = "../../../../../terraform-modules/db/rds/nonaurora"
  account             = data.aws_caller_identity.current.account_id
  database_name       = local.environment.database_name
  service             = local.environment.service
  environment         = local.environment.environment
  engine              = local.environment.engine
  kms_key_id          = module.kmskey.key_arn
  db_parameter_group  = local.environment.db_parameter_group
  snapshot_identifier = local.environment.snapshot_identifier
  required_tags       = local.environment.required_tags
  resource_tags       = local.environment.resource_tags

  depends_on = [module.kmskey.key_arn]
}


# Module used to create the Route53 dns records. Make sure your path for the source reflects your directory position
module "route53" {
  source          = "../../../../../terraform-modules/route53/db"
  name            = local.environment.service
  environment     = local.environment.environment
  writer_endpoint = module.nonaurora.rds_instance_address
  route53zone     = local.environment.route53zone

  depends_on = [module.nonaurora]
}

# Outputs info on app name after deploy
output "app_service_name" {
  value = local.environment.service
}

# Outputs info about account number after deploy
output "account" {
  description = "Account Number"
  value       = data.aws_caller_identity.current.account_id
}

# Outputs dns record after deploy (writer)
output "writer_endpoint" {
  value = module.route53.dns_writer
}

# Outputs dns record after deploy (reader)
output "reader_endpoint" {
  value = module.route53.dns_reader
}
