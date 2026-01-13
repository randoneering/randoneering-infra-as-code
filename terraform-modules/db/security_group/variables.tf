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

variable "engine" {
  description = "Engine value"
  type        = string
  default     = ""

}

variable "vpc_id" {
  type        = map(string)
  description = "Map of VPC IDs for different environments"
  default = {
    nameofenv = "vpc-id#"
  }
}


variable "required_tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "resource_tags" {
  description = "Tags to set for resources"
  type        = map(string)
  default = {
    owner     = "justin@randoneering.tech"
    terraform = "true"
  }
}
