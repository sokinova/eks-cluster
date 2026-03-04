output "external_dns_role_name" {
  description = "IAM role name for ExternalDNS IRSA"
  value       = aws_iam_role.external_dns.name
}

output "external_dns_role_arn" {
  description = "IAM role ARN assumed by ExternalDNS via IRSA"
  value       = aws_iam_role.external_dns.arn
}

output "external_dns_policy_arn" {
  description = "IAM policy ARN granting Route53 permissions to ExternalDNS"
  value       = aws_iam_policy.external_dns.arn
}