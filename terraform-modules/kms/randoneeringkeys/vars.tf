
variable "name" {
  type    = string
  default = ""
}

variable "environment" {
  type    = string
  default = ""
}

variable "randoneering_iam_role" {
  type    = string
  default = ""
}

variable "randoneering_iam_role_arn" {
  type    = string
  default = ""
}

variable "account" {
  type    = string
  default = ""
}


variable "use_custom_alias" {
  type        = bool
  description = "Use this if you need to create a new kms key when there is already one with a similiar name, or you simply need to make a custom name for the kms key other than our default"
  default     = false
}

variable "custom_kms_key_alias" {
  type        = string
  description = "Use this if you need to create a new kms key when there is already one with a similiar name, or you simply need to make a custom name for the kms key other than our default"
  default     = ""
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

variable "databases" {
  type        = list(string)
  default     = []
  description = "used for dr_kms_copy"
}
