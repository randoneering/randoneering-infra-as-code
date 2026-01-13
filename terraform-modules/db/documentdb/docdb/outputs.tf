output "account" {
  value = var.account
}

output "service_name" {
  description = "Name of the instance"
  value       = var.service_name_instance
}

output "endpoint" {
  value = aws_docdb_cluster.docdb.endpoint
}

output "instance_arn" {
  value = aws_docdb_cluster.docdb.arn
}
