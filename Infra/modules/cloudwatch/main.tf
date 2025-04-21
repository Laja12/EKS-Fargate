resource "aws_cloudwatch_log_group" "eks_cluster_log_group" {
  name_prefix        = "/aws/eks/${var.cluster_name}"
  retention_in_days  = var.log_retention_days

  tags = {
    Name = "${var.cluster_name}-logs"
  }
}

