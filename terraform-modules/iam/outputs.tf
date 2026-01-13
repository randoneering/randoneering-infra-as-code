output "name" {
  value       = var.create_iam_role ? aws_iam_role.iam_role[0].name : data.aws_iam_role.existing[0].name
  description = "The name of the IAM role created"
}

output "id" {
  value       = var.create_iam_role ? aws_iam_role.iam_role[0].id : data.aws_iam_role.existing[0].id
  description = "The stable and unique string identifying the role"
}

output "arn" {
  value       = var.create_iam_role ? aws_iam_role.iam_role[0].arn : data.aws_iam_role.existing[0].arn
  description = "The Amazon Resource Name (ARN) specifying the role"
}
