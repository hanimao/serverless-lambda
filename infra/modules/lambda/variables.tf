variable "project_name" {
  type = string
  default = "webapi"
}

variable "environment" {
  type = string
  default = "dev"
}


variable "log_retention_days" {
  type    = number
  default = 7
}


variable "tags" {
  type    = map(string)
  default = {}
}


variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}


variable "db_host" {
  type = string
}

variable "db_port" {
  type = number
  default = 1433
}


variable "db_secret_arn" {
  type      = string
  sensitive = true
}

