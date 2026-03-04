# Creates a managed IAM policy in AWS using the JSON built below
resource "aws_iam_policy" "external_dns" {
  name        = "${var.environment}-${var.cluster_name}-external-dns-route53"
  description = "Allow external-dns to manage Route53 records in approved hosted zones"
  policy      = data.aws_iam_policy_document.external_dns_permissions.json
}

# Builds JSON defining Route53 permissions, used in the IAM policy above
# permission edit records in specific zones + list zones 
data "aws_iam_policy_document" "external_dns_permissions" {
  statement {
    effect = "Allow"
    actions = [
      "route53:ChangeResourceRecordSets", # create, update, delete DNS records
      "route53:ListResourceRecordSets",   # read existing records
      "route53:ListTagsForResources",     # needed to match hosted zones correctly
      "route53:GetHostedZone",            # fetch zone metadata
    ]

    resources = [
      for id in var.hosted_zone_ids :
      "arn:aws:route53:::hostedzone/${id}" # external-dns can ONLY touch the hosted zones you pass in
    ]
  }

  # Discovery/ read-only access so external-dns can discover hosted zones first
  statement {
    effect = "Allow"
    actions = [
      "route53:ListHostedZones",       # allows listing all hosted zones in the account
      "route53:ListHostedZonesByName", # allows lookup by DNS name
    ]

    # Must be "*" because AWS does not support resource-level control here
    resources = ["*"]
  }
}

# creates the IAM role assumed by the Kubernetes ServiceAccount with trust policy (IRSA role)
resource "aws_iam_role" "external_dns" {
  name               = "${var.environment}-${var.cluster_name}-external-dns-irsa"
  assume_role_policy = data.aws_iam_policy_document.external_dns_trust.json
}

# Builds trust policy JSON allowing the EKS ServiceAccount to assume the role
data "aws_iam_policy_document" "external_dns_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.oidc_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:${var.namespace}:${var.service_account_name}"]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]

    }
  }
}

# Attaches the Route53 permissions policy to the external-dns IAM role
resource "aws_iam_role_policy_attachment" "external_dns_attach" {
  role       = aws_iam_role.external_dns.name
  policy_arn = aws_iam_policy.external_dns.arn
}