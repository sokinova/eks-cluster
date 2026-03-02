variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the cluster will be deployed"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "instance_types" {
  description = "List of instance types for worker nodes"
  type        = list(string)
  default     = ["t3.medium", "t3a.medium"]
}

variable "desired_capacity" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 5
}

variable "admin_role_arn" {
  description = "ARN of the IAM role that gets admin access to the cluster (e.g., AWS SSO Admin role)"
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