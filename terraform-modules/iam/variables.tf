variable "iam_role_name" {
  description = "Name of Target IAM Role"
  type        = string
  default     = ""
}

variable "iam_role_description" {
  description = "Description of Targe IAM Role"
  type        = string
  default     = ""
}


variable "managed_policy_arns" {
  type        = set(string)
  description = "List of managed policies to attach to created role"
  default     = []
}


variable "max_session_duration" {
  type        = number
  default     = 3600
  description = "The maximum session duration (in seconds) for the role. Can have a value from 1 hour to 12 hours"
}

variable "permissions_boundary" {
  type        = string
  default     = ""
  description = "ARN of the policy that is used to set the permissions boundary for the role"
}

variable "aws_service" {
  type        = string
  default     = ""
  description = "Name of the service role is to be assumed by. Format 'service.amazonaws.com'"

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

variable "create_iam_role" {
  description = "Input if a role needs to be created for the AWS Backup Plan and Vault. "
  type        = bool
  default     = true

}
