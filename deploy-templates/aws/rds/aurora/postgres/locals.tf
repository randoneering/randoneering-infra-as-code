locals {
  environment_configs = {
    environment = {
      service             = ""
      database_name       = ""
      source_region       = "us-west-2"
      environment         = ""
      engine              = "aurora-postgresql"
      snapshot_identifier = ""
      route53zone         = ""
      cluster_parameter_group = [
        {
          name         = "autovacuum"
          value        = "1"
          apply_method = "immediate"
        },
        {
          name         = "autovacuum_analyze_threshold"
          value        = "0"
          apply_method = "immediate"
        },
        {
          name         = "autovacuum_naptime"
          value        = "15"
          apply_method = "immediate"
        },
        {
          name         = "autovacuum_vacuum_cost_delay"
          value        = "20"
          apply_method = "immediate"
        },
        {
          name         = "autovacuum_vacuum_scale_factor"
          value        = "0.5"
          apply_method = "immediate"
        },
        {
          name         = "autovacuum_vacuum_threshold"
          value        = "50"
          apply_method = "immediate"
        },
        {
          name         = "pg_stat_statements.max"
          value        = "50000"
          apply_method = "pending-reboot"
        },
        {
          name         = "pg_stat_statements.track"
          value        = "ALL"
          apply_method = "immediate"
        },
        {
          name         = "pg_stat_statements.track_utility"
          value        = "0"
          apply_method = "immediate"
        },
        {
          name         = "rds.force_ssl"
          value        = "0"
          apply_method = "immediate"
        },
        {
          name         = "rds.logical_replication"
          value        = "1"
          apply_method = "pending-reboot"
        },
        {
          name         = "shared_preload_libraries"
          value        = "pg_stat_statements,pg_cron"
          apply_method = "pending-reboot"
        },
        {
          name         = "track_activity_query_size"
          value        = "50000"
          apply_method = "pending-reboot"
        },
        {
          name         = "track_counts"
          value        = "1"
          apply_method = "immediate"
        }
      ]
      required_tags = {
        owner     = ""
        terraform = "true"
      }
      resource_tags = {
      }
    }
  }
  # Retrieve the environment-specific configuration based on the var.environment
  environment = local.environment_configs[terraform.workspace]
}
