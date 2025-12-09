variable "aws_region" {
  type    = string
  default = "eu-west-2"
}

variable "project_name" {
  type = string
}


variable "db_master_username" {
  type = string
}


variable "db_allocated_storage" {
  type = number
  default = 10
}


variable "log_retention_days" {
  type = number
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "db_instance_class" {
  type = string
}

variable "db_name" {
  type = string
}
