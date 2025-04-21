resource "aws_cloudwatch_log_group" "eks_cluster_log_group" {
  name_prefix = "/aws/eks/${var.cluster_name}"
  retention_in_days = var.log_retention_days

  tags = {
    Name = "${var.cluster_name}-logs"
  }
}

resource "aws_eks_cluster" "update_logging" {
  depends_on = [aws_cloudwatch_log_group.eks_cluster_log_group]
  name       = var.cluster_name
  role_arn   = var.cluster_role_arn
  vpc_config {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = [var.cluster_security_group_id]
  }
  version = var.kubernetes_version

  logging {
    cluster_logging {
      enabled = true
      types = [
        "api",
        "audit",
        "authenticator",
        "controllerManager",
        "scheduler",
      ]
    }
  }
}
