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

# External DNS IRSA setup
data "aws_route53_zone" "selected" {
  for_each     = toset(var.hosted_zone_names)
  name         = each.value
  private_zone = false
}

module "external_dns_irsa" {
  source = "../external-dns-irsa"

  environment          = var.environment
  cluster_name         = var.cluster_name
  hosted_zone_ids      = [for z in data.aws_route53_zone.selected : z.zone_id]
  oidc_arn             = module.eks-module.oidc_provider_arn
  oidc_url             = module.eks-module.cluster_oidc_issuer
  namespace            = var.external_dns_namespace
  service_account_name = var.external_dns_sa_name
}