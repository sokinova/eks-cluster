variable "region" {
  description = "AWS region"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs"
  type        = list(string)
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
}

variable "admin_role_arn" {
  description = "ARN of IAM role for cluster admin access"
  type        = string
}

variable "admin_user_arns" {
  description = "ARNs of IAM users for cluster admin access"
  type        = list(string)
  default     = []
}

variable "github_runner_role_arns" {
  description = "ARNs of GitHub Actions runner IAM roles"
  type        = list(string)
  default     = []
}

#External DNS

variable "external_dns_namespace" {
  type = string
}

variable "hosted_zone_names" {
  description = "List of Route53 hosted zone names for external-dns"
  type        = list(string)
  default     = []
}

variable "external_dns_sa_name" {
  description = "Kubernetes service account name for external-dns"
  type        = string
  default     = "external-dns"
}