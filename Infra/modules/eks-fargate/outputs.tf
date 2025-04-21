output "cluster_id" {
  value = aws_eks_cluster.fargate.id
}

output "cluster_endpoint" {
  value = aws_eks_cluster.fargate.endpoint
}

output "cluster_certificate_authority_data" {
  value = aws_eks_cluster.fargate.certificate_authority.0.data
}
