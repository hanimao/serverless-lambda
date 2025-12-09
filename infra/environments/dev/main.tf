module "networking" {
  source = "../../modules/networking"

}

module "database" {
  source = "../../modules/database"

  project_name       = var.project_name
  environment        = var.environment
  vpc_id             = module.networking.vpc_id
  private_subnet_ids = module.networking.private_subnet_ids
  instance_class     = var.db_instance_class
  master_username    = var.db_master_username

}

module "lambda" {
  source = "../../modules/lambda"

  project_name       = var.project_name
  environment        = var.environment
  vpc_id             = module.networking.vpc_id
  private_subnet_ids = module.networking.private_subnet_ids
  log_retention_days = var.log_retention_days
  db_host            = module.database.address
  db_port            = module.database.port
  db_secret_arn      = module.database.db_secret_arn


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








