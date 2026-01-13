locals {
  vpc_id = var.vpc_id == "" ? lookup(var.vpc_ids, var.environment, "vpc-not-found") : var.vpc_id
}


data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [local.vpc_id]
  }

  tags = {
    Database = "True"
  }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "db-subnet-group-private"
  subnet_ids = data.aws_subnets.private.ids

  tags = merge(var.resource_tags, var.required_tags)
}


output "subnet_ids" {
  value = data.aws_subnets.private.ids
}

output "local-vpc-id" {
  value = local.vpc_id

}
