output "account" {
  description = "Account"
  value       = var.account
}

output "service_name" {
  description = "Name of the instance"
  value       = var.service
}

output "rds_instance_endpoint" {
  description = "A list of all instance endpoints"
  value       = aws_db_instance.rds_instance.endpoint
}

output "master_password" {
  description = "Master password"
  value       = random_password.password.result
}

output "rds_instance_address" {
  description = "The hostname of the RDS instance, without the port"
  value       = aws_db_instance.rds_instance.address

}

output "rds_instance_arn" {
  description = "The ID of the instance"
  value       = aws_db_instance.rds_instance.arn
}

output "rds_instance_id" {
  description = "The ID of the instance"
  value       = aws_db_instance.rds_instance.id
}


output "rds_instance_database_name" {
  description = "Name for an automatically created database on instance creation"
  value       = var.database_name
}

output "rds_instance_master_username" {
  description = "The master username"
  value       = aws_db_instance.rds_instance.username
}
