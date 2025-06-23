module "vpc" {
  source = "./modules/vpc"

  environment                  = var.environment
  project                      = var.project
  vpc_cidr                     = var.vpc_cidr
  availability_zones           = var.availability_zones
  public_subnet_cidrs          = var.public_subnet_cidrs
  private_subnet_fargate_cidrs = var.private_subnet_fargate_cidrs
  private_subnet_db_cidrs      = var.private_subnet_db_cidrs
}

module "alb" {
  source = "./modules/alb"

  environment       = var.environment
  project           = var.project
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  certificate_arn   = var.certificate_arn

  tags = {
    Project = var.project
  }
}

module "ecs" {
  source = "./modules/ecs"

  environment      = var.environment
  project          = var.project
  vpc_id           = module.vpc.vpc_id
  subnet_ids       = module.vpc.private_fargate_subnet_ids
  container_image  = var.container_image
  task_cpu         = var.task_cpu
  task_memory      = var.task_memory
  desired_count    = var.desired_count
  aws_region       = var.aws_region
  target_group_arn = module.alb.target_group_arn

  tags = {
    Project = var.project
  }
}

module "db" {
  source = "./modules/db"

  environment       = var.environment
  project           = var.project
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.private_db_subnet_ids
  subnet_group_name = module.vpc.db_subnet_group_name
  aurora_min_acu    = var.aurora_min_acu
  aurora_max_acu    = var.aurora_max_acu
  database_name     = var.database_name
  master_username   = var.master_username
}

module "cache" {
  source = "./modules/cache"

  environment       = var.environment
  project           = var.project
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.private_db_subnet_ids
  cache_node_type   = var.cache_node_type
  cache_num_nodes   = var.cache_num_nodes
  cache_port        = var.cache_port
}