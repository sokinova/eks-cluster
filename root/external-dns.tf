# resource "aws_iam_role" "external_dns" {
#   name = "${var.environment}-${var.cluster_name}-external-dns-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = {
#           Federated = module.eks.oidc_provider_arn # ← module output
#         }
#         Action = "sts:AssumeRoleWithWebIdentity"
#         Condition = {
#           StringEquals = {
#             "${replace(module.eks.oidc_provider_url, "https://", "")}:sub" = "system:serviceaccount:external-dns:external-dns"
#             "${replace(module.eks.oidc_provider_url, "https://", "")}:aud" = "sts.amazonaws.com"
#           }
#         }
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy" "external_dns" {
#   name = "${var.environment}-${var.cluster_name}-external-dns-policy"
#   role = aws_iam_role.external_dns.id

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           "route53:ChangeResourceRecordSets"
#         ]
#         Resource = "arn:aws:route53:::hostedzone/*"
#       },
#       {
#         Effect = "Allow"
#         Action = [
#           "route53:ListHostedZones",
#           "route53:ListResourceRecordSets",
#           "route53:ListTagsForResource"
#         ]
#         Resource = "*"
#       }
#     ]
#   })
# }