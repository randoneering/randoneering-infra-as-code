locals {
  iam_role_name                     = var.iam_role_name
  iam_role_arn                      = var.iam_role_arn
  vault_name                        = var.vault_name
  plan_name                         = var.plan_name
  backup_restore_plan               = var.backup_restore_plan
  backup_restore_resource_selection = var.backup_restore_resource_selection

}

resource "aws_backup_vault" "randoneering-backup-vault" {
  for_each = tomap({ for idx, name in local.vault_name : idx => name })

  name        = local.vault_name[each.key]
  kms_key_arn = var.kms_key_arn

  tags = merge(var.required_tags, var.resource_tags)
}

resource "aws_backup_vault_lock_configuration" "vault_lock" {
  for_each = tomap({ for idx, name in local.vault_name : idx => name })

  backup_vault_name   = aws_backup_vault.randoneering-backup-vault[each.key].name
  changeable_for_days = var.backup_vault_lock_configuration.changeable_for_days
  max_retention_days  = var.backup_vault_lock_configuration.max_retention_days
  min_retention_days  = var.backup_vault_lock_configuration.min_retention_days

}

resource "aws_backup_plan" "randoneering-backups" {
  for_each = tomap({ for idx, name in local.plan_name : idx => name })

  name = local.plan_name[each.key]

  dynamic "rule" {
    for_each = var.rules

    content {
      rule_name                = lookup(rule.value, "name", "${rule.key}")
      target_vault_name        = aws_backup_vault.randoneering-backup-vault[each.key].name
      schedule                 = rule.value.schedule
      start_window             = rule.value.start_window
      completion_window        = rule.value.completion_window
      recovery_point_tags      = var.resource_tags
      enable_continuous_backup = rule.value.enable_continuous_backup

      dynamic "lifecycle" {
        for_each = lookup(rule.value, "lifecycle", null) != null ? [true] : []

        content {
          cold_storage_after                        = rule.value.lifecycle.cold_storage_after
          delete_after                              = rule.value.lifecycle.delete_after
          opt_in_to_archive_for_supported_resources = rule.value.lifecycle.opt_in_to_archive_for_supported_resources
        }
      }

      dynamic "copy_action" {
        for_each = try(lookup(rule.value.copy_action, "destination_vault_arn", null), null) != null ? [true] : []

        content {
          destination_vault_arn = rule.value.copy_action.destination_vault_arn

          dynamic "lifecycle" {
            for_each = lookup(rule.value.copy_action, "lifecycle", null) != null ? [true] : []

            content {
              cold_storage_after                        = rule.value.copy_action.lifecycle.cold_storage_after
              delete_after                              = rule.value.copy_action.lifecycle.delete_after
              opt_in_to_archive_for_supported_resources = rule.value.lifecycle.opt_in_to_archive_for_supported_resources
            }
          }
        }
      }
    }
  }

  dynamic "advanced_backup_setting" {
    for_each = var.advanced_backup_setting != null ? [true] : []

    content {
      backup_options = var.advanced_backup_setting.backup_options
      resource_type  = var.advanced_backup_setting.resource_type
    }
  }

  tags = merge(var.required_tags, var.resource_tags)
}

resource "aws_backup_selection" "randoneering-backup-selection" {
  for_each = tomap({ for idx, name in local.plan_name : idx => name })

  name          = "${local.plan_name[each.key]}-backup-selection"
  iam_role_arn  = local.iam_role_arn
  plan_id       = aws_backup_plan.randoneering-backups[each.key].id
  resources     = var.backup_resources
  not_resources = var.not_resources
  dynamic "selection_tag" {
    for_each = var.selection_tags
    content {
      type  = selection_tag.value["type"]
      key   = selection_tag.value["key"]
      value = selection_tag.value["value"]
    }
  }
}
