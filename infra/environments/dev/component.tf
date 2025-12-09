resource "aws_vpc_endpoint" "main" {
  vpc_id             = module.networking.vpc_id
  private_dns_enabled = true 
  vpc_endpoint_type  = "Interface"
  subnet_ids         = module.networking.private_subnet_ids
  security_group_ids = [aws_security_group.vpc_endpoint.id]
  service_name       = "com.amazonaws.eu-west-2.secretsmanager"

  tags = {
    Environment = "dev"
  }
  depends_on = [module.lambda]
}


resource "aws_security_group" "vpc_endpoint" {
  name        = "${var.project_name}-${var.environment}-endpoint-sg"
  description = "Security group for vpc endpoint"
  vpc_id      = module.networking.vpc_id

ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
   security_groups = [module.lambda.security_group_id]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-endpoint-sg"
  })
}

resource "aws_security_group_rule" "lambda_to_rds" {
  type                     = "ingress"
  from_port                = 1433
  to_port                  = 1433
  protocol                 = "tcp"
  security_group_id        = module.database.security_group_id
  source_security_group_id = module.lambda.security_group_id
  description              = "Allow Lambda to connect to RDS"
  depends_on               = [module.lambda]
}