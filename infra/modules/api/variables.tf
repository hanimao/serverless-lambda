variable "project_name" {
  type = string
  default = "node-api"
}

variable "environment" {
  type = string
  default = "dev"
}

variable "lambda_invoke_arn" {
  type = string
}

variable "log_retention_days" {
  type    = number
  default = 7
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "lambda_function_name" {
  type        = string
  description = "Name of the Lambda function to integrate with API Gateway"
}
