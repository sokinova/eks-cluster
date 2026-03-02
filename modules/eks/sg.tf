# ==========================================================
# SECURITY GROUP: EKS Cluster (Control Plane)
# ==========================================================
resource "aws_security_group" "cluster" {
  name        = "${var.environment}-${var.cluster_name}-cluster-sg"
  description = "Security group for EKS cluster control plane"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "${var.environment}-${var.cluster_name}-cluster-sg"
    Environment = var.environment
  }
}

# ==========================================================
# SECURITY GROUP: Worker Nodes
# ==========================================================
resource "aws_security_group" "worker_node" {
  name        = "${var.environment}-${var.cluster_name}-worker-sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "${var.environment}-${var.cluster_name}-worker-sg"
    Environment = var.environment
  }
}

# ==========================================================
# SECURITY GROUP RULES: Cluster
# ==========================================================

# Worker nodes -> Cluster API (HTTPS)
resource "aws_security_group_rule" "cluster_ingress_from_workers" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.cluster.id
  source_security_group_id = aws_security_group.worker_node.id
  description              = "Allow worker nodes to communicate with cluster API"
}

# Cluster -> Workers (kubelet and extensions)
resource "aws_security_group_rule" "cluster_egress_to_workers" {
  type                     = "egress"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_security_group.cluster.id
  source_security_group_id = aws_security_group.worker_node.id
  description              = "Allow cluster to communicate with worker kubelets and pods"
}
# ==========================================================
# SECURITY GROUP RULES: Worker Nodes
# ==========================================================

# Node-to-node communication (all traffic)
resource "aws_security_group_rule" "worker_ingress_self" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.worker_node.id
  source_security_group_id = aws_security_group.worker_node.id
  description              = "Allow workers to communicate with each other"
}

# Cluster -> Workers (kubelet)
resource "aws_security_group_rule" "worker_ingress_from_cluster" {
  type                     = "ingress"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_security_group.worker_node.id
  source_security_group_id = aws_security_group.cluster.id
  description              = "Allow cluster control plane to communicate with worker nodes"
}

# Cluster -> Workers (HTTPS for extensions like metrics-server)
resource "aws_security_group_rule" "worker_ingress_from_cluster_https" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.worker_node.id
  source_security_group_id = aws_security_group.cluster.id
  description              = "Allow cluster to reach worker nodes on HTTPS"
}

# Workers outbound (internet access)
resource "aws_security_group_rule" "worker_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.worker_node.id
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow workers to reach the internet"
}