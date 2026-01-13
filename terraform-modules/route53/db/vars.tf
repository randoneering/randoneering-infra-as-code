variable "name" {
  type        = string
  description = "Name of the application"
  default     = ""
}
variable "environment" {
  type        = string
  description = "Name of environment"
  default     = ""
}
variable "route53zone" {
  type        = string
  description = "target route 53 hosted zone"
  default     = ""
}

variable "writer_endpoint" {
  type        = string
  description = "writer endpoint for rds instance"
  default     = ""
}

variable "reader_needed" {
  description = "Is a reader endpoint needed? This really only applies to non aurora, as non aurora rds instances dont have reader endpoints by default"
  type        = bool
  default     = false


}
variable "reader_endpoint" {
  type        = string
  description = "reader endpoint for rds instance"
  default     = ""
}

variable "use_custom_writer_name" {
  description = "Determine if a custom dns name for the writer is needed from the default set in the main.tf of this module"
  type        = bool
  default     = false
}

variable "custom_writer_name" {
  description = "To be used if there needs to be a specific, custom name for the dns writer that differs from the default"
  type        = string
  default     = ""
}

variable "use_custom_reader_name" {
  description = "Determine if a custom dns name for the reader is needed from the default set in the main.tf of this module"
  type        = bool
  default     = false
}

variable "custom_reader_name" {
  description = "To be used if there needs to be a specific, custom name for the dns reader that differs from the default"
  type        = string
  default     = ""
}