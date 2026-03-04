variable "environment" {
  description = "Deployment environment (dev, stage, prod)"
  type        = string
}

variable "oidc_arn" {
  description = "OIDC provider ARN for the EKS cluster"
  type        = string
}

variable "oidc_url" {
  description = "OIDC provider URL for the EKS cluster"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace where external-dns runs"
  type        = string
}

variable "service_account_name" {
  description = "ServiceAccount name for external-dns"
  type        = string
}

variable "hosted_zone_ids" {
  description = "Route53 hosted zone ID external-dns can manage"
  type        = list(string)
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}