locals {

}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["${var.aws_service}.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_role" "existing" {
  count = var.create_iam_role ? 0 : 1
  name  = var.iam_role_name
}

resource "aws_iam_role" "iam_role" {
  count                = var.create_iam_role ? 1 : 0
  name                 = var.iam_role_name
  description          = var.iam_role_description
  assume_role_policy   = data.aws_iam_policy_document.assume_role.json
  max_session_duration = var.max_session_duration
  permissions_boundary = var.permissions_boundary
  tags                 = merge(var.required_tags, var.resource_tags)
}

resource "aws_iam_role_policy_attachment" "managed" {
  for_each   = var.managed_policy_arns
  role       = var.iam_role_name
  policy_arn = each.key
}

