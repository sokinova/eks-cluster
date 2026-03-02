module "vpc" {
  source = "../modules/vpc"

  vpc_cidr             = var.vpc_cidr
  cluster_name         = var.cluster_name
  environment          = var.environment
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "eks" {
  source = "../modules/eks"

  cluster_name            = var.cluster_name
  cluster_version         = var.cluster_version
  environment             = var.environment
  vpc_id                  = module.vpc.vpc_id
  public_subnet_ids       = module.vpc.public_subnet_ids
  admin_role_arn          = var.admin_role_arn
  admin_user_arns         = var.admin_user_arns
  github_runner_role_arns = var.github_runner_role_arns

  depends_on = [module.vpc]
}