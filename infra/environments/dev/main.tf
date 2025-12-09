data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }

  filter {
    name   = "tag:Name"
    values = ["${var.environment}-private-subnet"]
  }
}

data "aws_subnets" "private-b" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }

  filter {
    name   = "tag:Name"
    values = ["${var.environment}-private-subnet2"]
  }
}


data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
     values = ["${var.environment}-vpc"]
  }
}


module "database" {
  source = "../../modules/database"

  project_name           = var.project_name
  environment            = var.environment
  database_name           = var.db_name
  vpc_id                 = data.aws_vpc.main.id
  # security_groups = [aws_security_group.rds.id]
  private_subnet_ids     = concat(
    data.aws_subnets.private.ids,
    data.aws_subnets.private-b.ids
  )
  instance_class         = var.db_instance_class
  master_username        = var.db_master_username

}

module "lambda" {
  source = "../../modules/lambda"

  project_name       = var.project_name
  environment        = var.environment
  vpc_id             = data.aws_vpc.main.id
  private_subnet_ids = concat(
    data.aws_subnets.private.ids,
    data.aws_subnets.private-b.ids
  )
  # memory_size        = 512
  log_retention_days = var.log_retention_days

  db_host       = module.database.address
  db_port       = module.database.port
  db_name       = module.database.database_name
  db_secret_arn = module.database.db_secret_arn


 depends_on = [module.database]
}



module "api" {
  source = "../../modules/api"

  project_name         = var.project_name
  environment          = var.environment
  lambda_invoke_arn    = module.lambda.invoke_arn
  lambda_function_name = module.lambda.function_name
  log_retention_days   = var.log_retention_days
}

# module "networking" {
#   source = "../../modules/networking"

# }









