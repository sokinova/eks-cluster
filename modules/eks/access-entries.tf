# Admin access for SSO Admin role
resource "aws_eks_access_entry" "admin" {
  cluster_name  = aws_eks_cluster.main.name
  principal_arn = var.admin_role_arn
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "admin" {
  cluster_name  = aws_eks_cluster.main.name
  principal_arn = var.admin_role_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }
}

# Admin access for Admin user
resource "aws_eks_access_entry" "admin_users" {
  count         = length(var.admin_user_arns)
  cluster_name  = aws_eks_cluster.main.name
  principal_arn = var.admin_user_arns[count.index]
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "admin_users" {
  count         = length(var.admin_user_arns)
  cluster_name  = aws_eks_cluster.main.name
  principal_arn = var.admin_user_arns[count.index]
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  access_scope {
    type = "cluster"
  }
}

# GitHub Actions runner roles
resource "aws_eks_access_entry" "github_runners" {
  count = length(var.github_runner_role_arns)

  cluster_name  = aws_eks_cluster.main.name
  principal_arn = var.github_runner_role_arns[count.index]
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "github_runners" {
  count = length(var.github_runner_role_arns)

  cluster_name  = aws_eks_cluster.main.name
  principal_arn = var.github_runner_role_arns[count.index]
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }
}

resource "aws_eks_access_entry" "worker_nodes" {
  cluster_name  = aws_eks_cluster.main.name
  principal_arn = aws_iam_role.worker_node.arn
  type          = "EC2_LINUX"
}