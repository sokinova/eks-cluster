data "aws_ssm_parameter" "eks_ami" {
  name = "/aws/service/eks/optimized-ami/${var.cluster_version}/amazon-linux-2023/x86_64/standard/recommended/image_id"
}

# ==========================================================
# LAUNCH TEMPLATE
# ==========================================================
resource "aws_launch_template" "worker_nodes" {
  name_prefix   = "${var.environment}-${var.cluster_name}-worker-"
  image_id      = data.aws_ssm_parameter.eks_ami.value
  instance_type = var.instance_types[0]

  vpc_security_group_ids = [aws_security_group.worker_node.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.worker_node.name
  }

  user_data = base64encode(<<-EOF
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="BOUNDARY"

--BOUNDARY
Content-Type: application/node.eks.aws

---
apiVersion: node.eks.aws/v1alpha1
kind: NodeConfig
spec:
  cluster:
    name: ${var.cluster_name}
    apiServerEndpoint: ${aws_eks_cluster.main.endpoint}
    certificateAuthority: ${aws_eks_cluster.main.certificate_authority[0].data}
    cidr: ${aws_eks_cluster.main.kubernetes_network_config[0].service_ipv4_cidr}
  kubelet:
    flags:
      - --node-labels=node.kubernetes.io/lifecycle=spot,environment=${var.environment}

--BOUNDARY--
EOF
  )

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 20
      volume_type           = "gp3"
      delete_on_termination = true
      encrypted             = true
    }
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "${var.environment}-${var.cluster_name}-worker"
      Environment = var.environment
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}