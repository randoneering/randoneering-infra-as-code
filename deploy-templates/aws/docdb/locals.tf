locals {
  environment_configs = {
    deployment_branch = {
      name                         = ""      # Name of service. Used in several modules/variables to populate names for associated resources.
      s3_bucket                    = ""      # Name of tfstate's s3 bucket
      engine                       = "docdb" # Only value accepted here is docdb
      database_name                = ""      # Name of database.
      preferred_maintenance_window = ""
      backup_window                = "03:00-05:00" # Never change
      deletion_protection          = true          # Enables deletion protection. Disable when you need to destroy the cluster.
      number_of_instances          = 1             # Default is set to 1. If the cluster needs more or less nodes, change the number accordingly.
      source_region                = "us-west-2"   # Default region to deploy to is us-west-2
      environment                  = ""            # Name of environment to deploy to.
      docdbsecuritygp              = ""            # This is the required security group to deploy the cluster with. There is a security group for each engine, and specific to each acocunt and found in EC2 service in AWS Console. Search in security groups for "docdb_"
      required_tags = {
        owner     = "justin@randoneering.tech" # Should always be present, required in new accounts
        terraform = "true"                     # Keep so we can know what resources are managed by terraform/opentofu from a glance
        app       = ""                         # Name of app/service database is supporting
        env       = ""                         # Name of env to dpeloy to
      }
      resource_tags = {
      }
    }
  }
  # Retrieve the environment-specific configuration based on the var.environment
  environment = local.environment_configs[terraform.workspace]
}
