output "eks_node_role_arn" {
  value = aws_iam_role.eks_node_role.arn
}

output "eks_node_instance_profile_arn" {
  value = aws_iam_instance_profile.eks_node_profile.arn
}
