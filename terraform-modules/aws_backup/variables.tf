variable "kms_key_arn" {
  type        = string
  description = "The server-side encryption key that is used to protect your backups"
  default     = ""
}

variable "environment" {
  description = "The environment the resource is being deployed in"
  type        = string
  default     = ""
}

variable "rules" {
  type = list(object({
    name                     = string
    schedule                 = optional(string)
    enable_continuous_backup = optional(bool)
    start_window             = optional(number)
    completion_window        = optional(number)
    lifecycle = optional(object({
      cold_storage_after                        = optional(number)
      delete_after                              = optional(number)
      opt_in_to_archive_for_supported_resources = optional(bool)
    }))
    copy_action = optional(object({
      destination_vault_arn = optional(string)
      lifecycle = optional(object({
        cold_storage_after                        = optional(number)
        delete_after                              = optional(number)
        opt_in_to_archive_for_supported_resources = optional(bool)
      }))
    }))
  }))
  description = <<-EOT
   A list of rule objects used to define schedules in a backup plan. Follows the following structure:

    ```yaml
      rules:
        - name: "plan-daily"
          schedule: "cron(0 5 ? * * *)"
          start_window: 320 # 60 * 8             # minutes
          completion_window: 10080 # 60 * 24 * 7 # minutes
          delete_after: 35 # 7 * 5               # days
        - name: "plan-weekly"
          schedule: "cron(0 5 ? * SAT *)"
          start_window: 320 # 60 * 8              # minutes
          completion_window: 10080 # 60 * 24 * 7  # minutes
          delete_after: 90 # 30 * 3
    ```

    EOT
  default     = []
}

variable "advanced_backup_setting" {
  type = object({
    backup_options = string
    resource_type  = string
  })
  description = "An object that specifies backup options for each resource type"
  default     = null
}

variable "backup_resources" {
  type        = list(string)
  description = "An array of strings that either contain Amazon Resource Names (ARNs) or match patterns of resources to assign to a backup plan"
  default     = []
}

variable "not_resources" {
  type        = list(string)
  description = "An array of strings that either contain Amazon Resource Names (ARNs) or match patterns of resources to exclude from a backup plan"
  default     = []
}

variable "selection_tags" {
  type = list(object({
    type  = string
    key   = string
    value = string
  }))
  description = "An array of tag condition objects used to filter resources based on tags for assigning to a backup plan"
  default     = []
}

variable "vault_name" {
  type        = list(string)
  description = "Override target Vault Name"
  default     = []
}

variable "iam_role_name" {
  type        = string
  description = "Override target IAM Role Name"
  default     = ""
}

variable "iam_role_arn" {
  type        = string
  description = "Override target IAM Role Arnm"
  default     = ""
}

variable "backup_vault_lock_configuration" {
  type = object({
    changeable_for_days = optional(number)
    max_retention_days  = optional(number)
    min_retention_days  = optional(number)
  })
  description = <<-EOT
    The backup vault lock configuration, each vault can have one vault lock in place. This will enable Backup Vault Lock on an AWS Backup vault  it prevents the deletion of backup data for the specified retention period. During this time, the backup data remains immutable and cannot be deleted or modified."
    `changeable_for_days` - The number of days before the lock date. If omitted creates a vault lock in `governance` mode, otherwise it will create a vault lock in `compliance` mode.
  EOT
  default     = null
}

variable "required_tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "resource_tags" {
  description = "A map of tags to add to only the RDS cluster. Used for AWS Instance Scheduler tagging"
  type        = map(string)
  default     = {}
}

variable "plan_name" {
  description = "Name of plan(s)"
  type        = list(string)
  default     = []
}

variable "backup_restore_plan" {
  description = "Name of the backup_restore plan(s)"
  type        = list(string)
  default     = []
}

variable "recovery_point_selection" {
  description = "List of the "
  type = list(object({
    algorithm             = string
    include_vaults        = list(string)
    exclude_vaults        = list(string)
    recovery_point_types  = list(string)
    selection_window_days = number
  }))
  default = []
}

variable "testing_schedule" {
  description = "Schedule to use for backup_restore testing"
  type        = string
  default     = ""
}

variable "protected_resource_types" {
  description = "List of protected resource types to include in backup and restore testing"
  type        = list(string)
  default     = []
}

variable "protected_resource_arns" {
  description = "List of protected resources to include in backup_restore testing"
  type        = list(string)
  default     = []
}

variable "backup_restore_resource_selection" {
  description = ""
  type = list(object({
    name                       = string
    restore_testing_plan_name  = string
    protected_resource_type    = string
    iam_role_arn               = string
    protected_resource_arns    = list(string)
    restore_metadata_overrides = map(string)
    validation_window_hours    = number

  }))
  default = []
}

variable "include_vaults" {
  description = "List of vaults to include in testing"
  type        = list(string)
  default     = []
}

variable "schedule_expression_timezone" {
  description = "The timezone for the schedule expression. If not provided, the state value will be used."
  type        = string
  default     = "Etc/UTC"

}

variable "start_window_hours" {
  description = "The number of hours in the start window for the restore testing plan. Must be between 1 and 168."
  type        = number
  default     = 24
}


variable "selection_window_days" {
  description = "Specifies the number of days within which the recovery points should be selected. Must be a value between 1 and 365."
  type        = number
  default     = 31
}

variable "protected_resource_conditions" {
  description = ""
  type = list(object({
    string_equals = optional(list(object({
      key   = string
      value = string
    })))
    string_not_equals = optional(list(object({
      key   = string
      value = string
    })))
  }))
  default = []
}
