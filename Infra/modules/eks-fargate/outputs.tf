output "cluster_id" {
  value = aws_eks_cluster.fargate.id
}

output "cluster_endpoint" {
  value = aws_eks_cluster.fargate.endpoint
}

output "cluster_certificate_authority_data" {
  value = aws_eks_cluster.fargate.certificate_authority.0.data
}

output "cluster_name" {
  value = aws_eks_cluster.fargate.name
  description = "The name of the EKS cluster"
}

output "cluster_role_arn" {
  value = aws_iam_role.eks_cluster_role.arn
  description = "The ARN of the EKS cluster role"
}

output "cluster_security_group_id" {
  value = aws_security_group.eks_cluster_sg.id
  description = "The ID of the EKS cluster security group"
}

output "kubernetes_version" {
  value = var.kubernetes_version
  description = "The Kubernetes version for the EKS cluster"
}
