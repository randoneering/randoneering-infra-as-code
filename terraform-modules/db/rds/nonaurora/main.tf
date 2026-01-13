locals {
  name                            = var.service
  identifier                      = var.identifier == "" ? "${var.service}" : var.identifier
  username                        = var.username == "" ? "randoneering" : var.username
  master_password                 = var.password == "" ? random_password.password.result : var.password
  port                            = var.port == "" ? var.engine == "postgres" ? "5432" : "3306" : var.port
  engine                          = (var.engine == "" || var.engine == "postgres") ? "postgres" : "mysql"
  engine_version                  = var.engine == "postgres" ? "15.10" : "8.0.41"
  family                          = var.engine == "postgres" ? "postgres15" : "mysql8.0"
  instance_class                  = var.instance_class == "" ? "db.t4g.medium" : var.instance_class
  allocated_storage               = var.allocated_storage == "" ? 100 : var.allocated_storage
  iops                            = var.allocated_storage >= 100 ? 3000 : null
  storage_type                    = var.storage_type == "" ? "gp3" : var.storage_type
  snapshot_identifier             = var.snapshot_identifier == "" ? "" : var.snapshot_identifier
  db_subnet_group_name            = var.db_subnet_group_name == "" ? "db-subnet-group-private" : var.db_subnet_group_name
  enabled_cloudwatch_logs_exports = var.engine == "postgres" ? ["postgresql"] : ["audit", "error", "slowquery"]
  backup_retention_period         = var.environment == "prod" ? 14 : 3
  preferred_backup_window         = var.environment == "prod" ? "05:00-07:00" : "12:00-14:00"
  preferred_maintenance_window    = var.environment == "prod" ? "Tue:05:00-Tue:06:00" : "Sun:05:00-Sun:06:00"
  engine_security_group           = (var.engine == "aurora-postgresql" || var.engine == "postgres") ? data.aws_security_group.postgres.id : data.aws_security_group.mysql.id
  additional_security_groups      = var.additional_security_groups
}


data "aws_db_subnet_group" "db_subnetgroup" {
  name = local.db_subnet_group_name
}

data "aws_security_group" "postgres" {
  name = "db_postgres_default"
}



data "aws_security_group" "mysql" {
  name = "db_mysql_default"
}

data "aws_iam_role" "rds_monitoring_role" {
  name = "rds-monitoring-role"

}

resource "random_password" "password" {
  length  = 20
  special = false
}

resource "aws_db_instance" "rds_instance" {
  identifier                  = local.identifier
  engine                      = local.engine
  engine_version              = local.engine_version
  db_name                     = var.database_name
  username                    = local.username
  password                    = random_password.password.result
  instance_class              = local.instance_class
  parameter_group_name        = aws_db_parameter_group.param_group.name
  publicly_accessible         = false
  allocated_storage           = local.allocated_storage
  allow_major_version_upgrade = var.allow_major_version_upgrade
  apply_immediately           = var.apply_immediately
  availability_zone           = var.availability_zone
  final_snapshot_identifier   = "${var.service}-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  snapshot_identifier         = local.snapshot_identifier
  skip_final_snapshot         = false
  db_subnet_group_name        = local.db_subnet_group_name
  copy_tags_to_snapshot       = var.copy_tags_to_snapshot
  backup_retention_period     = local.backup_retention_period
  backup_window               = local.preferred_backup_window
  blue_green_update {
    enabled = var.blue_green_enabled
  }
  ca_cert_identifier                    = var.ca_cert_identifier
  delete_automated_backups              = var.delete_automated_backups
  monitoring_interval                   = var.monitoring_interval
  auto_minor_version_upgrade            = var.auto_minor_version_upgrade
  iam_database_authentication_enabled   = var.iam_database_authentication_enabled
  iops                                  = local.iops
  max_allocated_storage                 = var.max_allocated_storage
  monitoring_role_arn                   = data.aws_iam_role.rds_monitoring_role.arn
  multi_az                              = var.multi_az
  option_group_name                     = var.option_group_name
  enabled_cloudwatch_logs_exports       = local.enabled_cloudwatch_logs_exports
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_kms_key_id       = var.performance_insights_kms_key_id
  performance_insights_retention_period = var.performance_insights_retention_period
  storage_encrypted                     = true
  storage_type                          = local.storage_type
  storage_throughput                    = var.storage_throughput
  kms_key_id                            = var.kms_key_id
  vpc_security_group_ids                = flatten([local.engine_security_group])
  maintenance_window                    = local.preferred_maintenance_window
  deletion_protection                   = var.deletion_protection
  tags                                  = merge(var.resource_tags, var.required_tags)

  dynamic "restore_to_point_in_time" {
    for_each = var.restore_to_point_in_time != null ? [var.restore_to_point_in_time] : []

    content {
      restore_time                             = lookup(restore_to_point_in_time.value, "restore_time", null)
      source_db_instance_automated_backups_arn = lookup(restore_to_point_in_time.value, "source_db_instance_automated_backups_arn", null)
      source_db_instance_identifier            = lookup(restore_to_point_in_time.value, "source_db_instance_identifier", null)
      source_dbi_resource_id                   = lookup(restore_to_point_in_time.value, "source_dbi_resource_id", null)
      use_latest_restorable_time               = lookup(restore_to_point_in_time.value, "use_latest_restorable_time", null)
    }
  }


  dynamic "s3_import" {
    for_each = var.s3_import != null ? [var.s3_import] : []

    content {
      source_engine         = var.engine
      source_engine_version = s3_import.value.source_engine_version
      bucket_name           = s3_import.value.bucket_name
      bucket_prefix         = lookup(s3_import.value, "bucket_prefix", null)
      ingestion_role        = s3_import.value.ingestion_role
    }
  }
  lifecycle {
    ignore_changes = [snapshot_identifier, username, identifier]
  }
}

resource "aws_db_parameter_group" "param_group" {
  name        = "${var.service}-parameter-group"
  family      = local.family
  description = "${var.service}db-parameter-group"
  tags        = var.required_tags

  dynamic "parameter" {
    for_each = var.db_parameter_group

    content {
      apply_method = parameter.value.apply_method
      name         = parameter.value.name
      value        = parameter.value.value
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
