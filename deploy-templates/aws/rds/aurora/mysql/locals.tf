locals {
  environment_configs = {
    environment = {
      service             = ""          # Name of the service the database is being deployed for
      database_name       = ""          # Database name
      source_region       = "us-west-2" # Target region
      environment         = ""
      engine              = "aurora-mysql"
      snapshot_identifier = ""
      route53zone         = ""
      cluster_parameter_group = [
        {
          name         = "aurora_binlog_replication_max_yield_seconds"
          value        = "0"
          apply_method = "immediate"
        },
        {
          name         = "aurora_parallel_query"
          value        = "0"
          apply_method = "immediate"
        },
        {
          name         = "binlog_format"
          value        = "ROW"
          apply_method = "pending-reboot"
        },
        {
          name         = "connect_timeout"
          value        = "60"
          apply_method = "immediate"
        },
        {
          name         = "enforce_gtid_consistency"
          value        = "ON"
          apply_method = "pending-reboot"
        },
        {
          name         = "explicit_defaults_for_timestamp"
          value        = "0"
          apply_method = "pending-reboot"
        },
        {
          name         = "general_log"
          value        = "0"
          apply_method = "immediate"
        },
        {
          name         = "gtid-mode"
          value        = "ON"
          apply_method = "pending-reboot"
        },
        {
          name         = "innodb_adaptive_hash_index"
          value        = "1"
          apply_method = "immediate"
        },
        {
          name         = "innodb_adaptive_hash_index_parts"
          value        = "12"
          apply_method = "pending-reboot"
        },
        {
          name         = "innodb_lock_wait_timeout"
          value        = "300"
          apply_method = "immediate"
        },
        {
          name         = "innodb_purge_threads"
          value        = "1"
          apply_method = "pending-reboot"
        },
        {
          name         = "key_buffer_size"
          value        = "115343360"
          apply_method = "immediate"
        },
        {
          name         = "log_bin_trust_function_creators"
          value        = "1"
          apply_method = "immediate"
        },
        {
          name         = "long_query_time"
          value        = "600"
          apply_method = "immediate"
        },
        {
          name         = "max_allowed_packet"
          value        = "943718400"
          apply_method = "immediate"
        },
        {
          name         = "max_heap_table_size"
          value        = "4294967296"
          apply_method = "immediate"
        },
        {
          name         = "net_read_timeout"
          value        = "14400"
          apply_method = "immediate"
        },
        {
          name         = "performance_schema"
          value        = "1"
          apply_method = "pending-reboot"
        },
        {
          name         = "performance_schema_consumer_events_stages_current"
          value        = "0"
          apply_method = "pending-reboot"
        },
        {
          name         = "performance_schema_consumer_events_statements_current"
          value        = "1"
          apply_method = "pending-reboot"
        },
        {
          name         = "performance_schema_consumer_events_statements_history"
          value        = "1"
          apply_method = "pending-reboot"
        },
        {
          name         = "performance_schema_consumer_events_statements_history_long"
          value        = "1"
          apply_method = "pending-reboot"
        },
        {
          name         = "performance-schema-consumer-events-waits-current"
          value        = "ON"
          apply_method = "pending-reboot"
        },
        {
          name         = "performance_schema_max_digest_length"
          value        = "10000"
          apply_method = "pending-reboot"
        },
        {
          name         = "performance_schema_max_sql_text_length"
          value        = "10000"
          apply_method = "pending-reboot"
        },
        {
          name         = "max_digest_length"
          value        = "10000"
          apply_method = "pending-reboot"
        },
        {
          name         = "slow_query_log"
          value        = "1"
          apply_method = "immediate"
        },
        {
          name         = "sql_mode"
          value        = "STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION"
          apply_method = "immediate"
        },
        {
          name         = "thread_cache_size"
          value        = "12"
          apply_method = "immediate"
        },
        {
          name         = "tmp_table_size"
          value        = "1073741824"
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
