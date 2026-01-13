variable "account" {
  type    = string
  default = ""
}

variable "service_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "service_name_instance" {
  type        = string
  description = "The name of the application this database is being created for"
}

variable "number_of_instances" {
  type    = number
  default = 1
}

variable "instance_class" {
  type    = string
  default = "db.r6g.xlarge"
}

variable "db_engine" {
  type    = string
  default = "docdb"
}

variable "docdb_engine_version" {
  type    = string
  default = "5.0.0"
}

variable "admin_username" {
  type    = string
  default = "randoneering"
}
variable "engine_mode" {
  type    = string
  default = "provisioned"
}

variable "parameter_group" {
  type = string
}

variable "deletion_protection" {
  type    = string
  default = true
}

variable "kms_key_arn" {
  type = string
}

variable "database_name" {
  type = string
}

variable "rds_monitoring_role" {
  type    = string
  default = ""
}

variable "rds_monitoring_role_arn" {
  type    = string
  default = ""

}
variable "database_subnetgp" {
  type    = string
  default = ""
}

variable "iam_role" {
  type    = string
  default = ""
}

variable "docdbsecuritygp" {
  type    = string
  default = ""
}

variable "maintenance_window" {
  type    = string
  default = "Sun:05:00-Sun:05:30"
}

variable "backup_window" {
  type    = string
  default = "09:00-09:30"
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
