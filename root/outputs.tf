# VPC Outputs
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

# EKS cluster Outputs
output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

# External DNS Outputs
output "external_dns_role_arn" {
  description = "ARN of the External-DNS IAM role for IRSA"
  value       = aws_iam_role.external_dns.arn
}