locals {
  name = var.name != "" ? var.name : "name-of-bucket-${var.environment}-tfstate"

}
resource "aws_s3_bucket" "s3_bucket" {
  bucket = local.name


  dynamic "versioning" {
    for_each = var.enable_versioning ? [1] : []
    content {
      enabled = true
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default_encryption" {
  count  = var.use_custom_kms_key ? 0 : 1
  bucket = aws_s3_bucket.s3_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "kms_encryption" {
  count  = var.use_custom_kms_key ? 1 : 0
  bucket = aws_s3_bucket.s3_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.kms_key_id
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "s3_lifecycle" {
  count  = var.enable_lifecycle ? 1 : 0
  bucket = aws_s3_bucket.s3_bucket.bucket

  rule {
    id     = var.lifecycle_rule.id
    status = var.lifecycle_rule.status

    transition {
      days          = var.lifecycle_rule.transition_days
      storage_class = var.lifecycle_rule.storage_class
    }

    expiration {
      days = var.lifecycle_rule.expiration_days
    }
  }
  rule {
    id     = "AbortIncompleteMultipartUploads"
    status = "Enabled"

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }

  }
}

resource "aws_s3_bucket_policy" "db_access_policy" {
  bucket = aws_s3_bucket.s3_bucket.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllowSSLRequestsOnly",
        "Effect" : "Deny",
        "Principal" : "*",
        "Action" : "s3:*",
        "Resource" : [
          "arn:aws:s3:::${aws_s3_bucket.s3_bucket.id}",
          "arn:aws:s3:::${aws_s3_bucket.s3_bucket.id}/*"
        ],
        "Condition" : {
          "Bool" : {
            "aws:SecureTransport" : "false"
          }
        }
      },
      {
        "Sid" : "TeamOnlyAccess",
        "Effect" : "Deny",
        "Principal" : "*",
        "Action" : "s3:Put*",
        "Resource" : [
          "arn:aws:s3:::${aws_s3_bucket.s3_bucket.id}",
          "arn:aws:s3:::${aws_s3_bucket.s3_bucket.id}/*"
        ],
        "Condition" : {
          "StringNotEquals" : {
            "aws:PrincipalARN" : [
              "${var.iam_role}"
            ]
          }
        }
      }
    ]
  })
}
