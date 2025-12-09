output "api_endpoint" {
  value       = module.api.api_endpoint
  description = "API Gateway endpoint"
}

output "lambda_function_name" {
  value       = module.lambda.function_name
  description = "Lambda function name"
}

output "database_endpoint" {
  value       = module.database.endpoint
  description = "RDS database endpoint"
  sensitive   = true
}

output "artifacts_bucket" {
  value       = module.lambda.artifacts_bucket
  description = "S3 bucket for Lambda artifacts"
}