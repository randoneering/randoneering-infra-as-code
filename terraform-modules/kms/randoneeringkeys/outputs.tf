output "key_arn" {
  value = aws_kms_key.rds_kms_key.arn
}
output "kms_key_id" {
  value = aws_kms_key.rds_kms_key.id
}

output "app_name" {
  description = "Name of the instance"
  value       = var.name
}