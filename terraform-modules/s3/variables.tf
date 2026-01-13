variable "name" {
  description = "name of target s3 bucket"
  type        = string
  default     = ""
}

variable "iam_role_arn" {
  description = "Arn for the iam_role"
  type        = string
  default     = ""
}


variable "iam_role" {
  description = "name of the iam role"
  type        = string
  default     = ""
}
variable "environment" {
  description = "Environment deploying to"
  type        = string
  default     = ""

}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = ""
}

variable "enable_versioning" {
  description = "Enable versioning for the S3 bucket"
  type        = bool
  default     = true
}

variable "enable_lifecycle" {
  description = "Enable lifecycle rule for the S3 bucket"
  type        = bool
  default     = false
}
variable "lifecycle_rule" {
  description = "Lifecycle rule configuration"
  type = object({
    id              = string
    status          = string
    transition_days = number
    storage_class   = string
    expiration_days = number
  })
  default = {
    id              = "archive-events"
    status          = "Enabled"
    transition_days = 30
    storage_class   = "DEEP_ARCHIVE"
    expiration_days = 180
  }
}

variable "resource_tags" {
  description = "Tags to set for resources"
  type        = map(string)
  default = {
    owner     = "justin@randoneering.tech"
    terraform = "true"
  }
}

variable "required_tags" {
  description = "Tags required for resource"
  type        = map(string)
  default     = {}
}

variable "use_custom_kms_key" {
  description = "Set this to true if you wish to use a custom kms key (using our kms key module) or false to use default encryption."
  type        = bool
  default     = false
}

variable "kms_key_id" {
  description = "ID of the KMS key to encrypt the bucket with"
  type        = string
  default     = ""

}
