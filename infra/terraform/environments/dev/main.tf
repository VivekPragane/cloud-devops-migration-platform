############################################
# DEV ENVIRONMENT
# Purpose:
# - Wire all infrastructure modules together
# - Dev / learning environment (cost-aware)
############################################

############################################
# NETWORK (FOUNDATION)
############################################
module "network" {
  source = "../../modules/network"

  project_name = var.project_name
  environment  = var.environment

  # Public-only VPC (intentional for Free Tier)
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]

  # Explicit AZ selection for clarity (can be parameterized later)
  availability_zones = ["ap-south-1a", "ap-south-1b"]
}

############################################
# ECR (IMAGE REGISTRY)
############################################
module "ecr" {
  source = "../../modules/ecr"

  project_name = var.project_name
  environment  = var.environment
}

############################################
# ALB (MUST COME BEFORE ECS)
############################################
module "alb" {
  source = "../../modules/alb"

  project_name      = var.project_name
  environment       = var.environment
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
}

############################################
# ECS (COMPUTE + SERVICE)
############################################
module "ecs" {
  source = "../../modules/ecs"

  project_name = var.project_name
  environment  = var.environment

  aws_region = var.aws_region

  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids

  target_group_arn      = module.alb.target_group_arn
  alb_security_group_id = module.alb.alb_sg_id

  backend_image = "${module.ecr.repository_url}:latest"
}


