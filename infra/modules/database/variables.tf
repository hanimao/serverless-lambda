variable "project_name" {
  type = string
  default = "node-api"
}

variable "environment" {
  type = string
  default = "dev"
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "master_username" {
  type    = string
  default = "sqladmin"
}

variable "tags" {
  type    = map(string)
  default = {}
}


variable "instance_class" {
  type    = string
  default = "db.t3.medium"
}


