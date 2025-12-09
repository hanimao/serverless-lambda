resource "aws_security_group" "rds" {
  name        = "${var.project_name}-${var.environment}-rds-sg"
  description = "Security group for RDS SQL Server"
  vpc_id      = var.vpc_id
    


  ingress {
    from_port = 1433
    to_port   = 1433
    protocol  = "tcp"
   # cidr_blocks 
   security_groups = [aws_security_group.lambda.id]
 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-rds-sg"
  })
}



resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-${var.environment}-db-subnet"
  subnet_ids = var.private_subnet_ids

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-db-subnet"
  })
}

resource "random_password" "master" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}:?"

}

resource "aws_secretsmanager_secret" "db_credentials" {
  name                    = "${var.project_name}-${var.environment}-db-credentials"
  recovery_window_in_days = var.environment == "prod" ? 30 : 0

  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = var.master_username
    password = random_password.master.result
  })
}

resource "aws_db_instance" "main" {
  identifier = "${var.project_name}-${var.environment}-sql"

  engine                = "sqlserver-ex"
  license_model         = "license-included"
  instance_class        = "db.t3.medium"
  allocated_storage     = 20
  storage_type          = "gp3"
  storage_encrypted     = true
  db_name               = var.database_name
  username              = "sqladmin"
  password              = random_password.master.result
  port                  = 1433

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible    = false
  skip_final_snapshot       = true

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-sql"
  })
}



