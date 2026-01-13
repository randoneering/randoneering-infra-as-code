variable "account" {
  description = "Account number to deploy to"
  type        = string
  default     = ""

}

variable "name" {
  description = "Name given resources"
  type        = string
  default     = ""
}

variable "environment" {
  description = "Name of the environment deploying to"
  type        = string
  default     = ""
}


variable "subnet_group_name" {
  description = "Name of db subnet group if it is an existing subnet group"
  type        = string
  default     = ""
}
variable "subnets" {
  description = "List of subnet IDs to use"
  type        = list(string)
  default     = []
}

variable "required_tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "db_subnet_group_name" {
  description = "The subnet group name to use"
  type        = string
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

variable "vpc_ids" {
  type        = map(string)
  description = "Map of VPC IDs for different environments"
  default = {
    env = "vpc-id#"
  }
}

variable "vpc_id" {
  description = "If target vpc is not in the default vpc_ids variable, this variable can be used to select a specific vpc id"
  type        = string
  default     = ""
}
