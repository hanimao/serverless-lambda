output "function_arn" {
  value = aws_lambda_function.api.arn
}

output "function_name" {
  value = aws_lambda_function.api.function_name
}

output "invoke_arn" {
  value = aws_lambda_function.api.invoke_arn
}

output "security_group_id" {
  value = aws_security_group.lambda.id
}

output "artifacts_bucket_arn" {
  value = aws_s3_bucket.lambda_artifacts.arn
}

