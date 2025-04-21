resource "aws_eks_cluster" "fargate" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = [
      var.private_subnet_1_id,
      var.private_subnet_2_id,
    ]
    security_group_ids = [var.eks_cluster_sg_id]
  }

  version = var.kubernetes_version

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_vpc_cni_policy,
  ]

  tags = {
    Name = var.cluster_name
  }

  # Correctly configure EKS logging
  logging {
    cluster_logging {
      enabled = true
      types = [
        "api",
        "audit",
        "authenticator",
        "controllerManager",
        "scheduler"
      ]
    }
  }
}

resource "aws_cloudwatch_log_group" "eks_cluster_log_group" {
  name_prefix       = "/aws/eks/${var.cluster_name}"
  retention_in_days = 30

  tags = {
    Name = "${var.cluster_name}-logs"
  }
}

resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.cluster_name}-cluster-role"
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

# Other resources for EKS and Fargate profile...
