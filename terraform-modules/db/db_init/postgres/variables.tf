variable "replayable" {
  description = "Should the playbook be replayable? Default is false"
  type        = bool
  default     = false
}

variable "service_user" {
  description = "Name of app/service user for target database"
  type        = string
  default     = ""
}

variable "playbook_path" {
  description = "Path relevant from where you are deploying terraform resources from to your target playbook"
  type        = string
  default     = ""
}

variable "service_user_password" {
  description = "password for service user"
  type        = string
  default     = ""
}

variable "ansible_group" {
  description = "Name of group to create"
  type        = string
  default     = "ansible_group"
}

variable "ansible_host" {
  description = "Host of ansible runner"
  type        = string
  default     = ""
}

variable "ansible_runner_user" {
  description = "Service/User to run playbook with."
  type        = string
  default     = ""
}

variable "ansible_playbook_path" {
  description = "Path to playbook"
  type        = string
  default     = ""
}

variable "schema" {
  description = "Name of target schema"
  type        = string
  default     = "schema"
}

variable "dns_endpoint" {
  description = "Target endpoint for database cluster/instance"
  type        = string
  default     = ""
}

variable "database_name" {
  description = "Name of target database"
  type        = string
  default     = ""
}

variable "username" {
  description = "Name of master username."
  type        = string
  default     = "randoneering"

}

variable "master_username_password" {
  description = "Password for master username"
  type        = string
  default     = ""
}
