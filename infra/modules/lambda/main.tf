# creates your s3 bucket for your codee

resource "aws_s3_bucket" "lambda_artifacts" {
  bucket = "${var.project_name}-${var.environment}-lambda-artifacts"

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-lambda-artifacts"
  })
}

# Creates an IAM Role for a Lambda function
resource "aws_iam_role" "lambda" {
  name = "${var.project_name}-${var.environment}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })

  tags = var.tags
}

# lambda to create & manage ENIs 

resource "aws_iam_role_policy_attachment" "lambda_vpc" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}


resource "aws_security_group" "lambda" {
  name        = "${var.project_name}-${var.environment}-lambda-sg"
  description = "Security group for Lambda function"
  vpc_id      = var.vpc_id 

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-lambda-sg"
  })
}

resource "aws_lambda_function" "api" {
  function_name = "${var.project_name}-${var.environment}-api"
  role          = aws_iam_role.lambda.arn

  s3_bucket = aws_s3_bucket.lambda_artifacts.bucket
  s3_key    = "deployment.zip"

  handler     = "index.handler"
  runtime     = "nodejs20.x"
  timeout     = 60
  memory_size = 512

  vpc_config {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = [aws_security_group.lambda.id]
  }

  environment {
    variables = {
      NODE_ENV      = "dev"
      DB_USER       = "sqladmin"              
      DB_HOST       = var.db_host
      DB_PORT       = 1433
      DB_NAME       = "master"
      DB_SECRET_ARN = var.db_secret_arn
    }
  }

  tags = var.tags

}

# policy grants your Lambda function permission to read a specific secret from AWS Secrets Manager.


resource "aws_iam_policy" "lambda_secrets_policy" {
  name        = "${var.project_name}-${var.environment}-lambda-secrets"
  description = "Allow Lambda to read database secrets"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["secretsmanager:GetSecretValue"],
        Resource = var.db_secret_arn  # must be the full secret ARN
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_secrets_attach" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.lambda_secrets_policy.arn
}




resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
