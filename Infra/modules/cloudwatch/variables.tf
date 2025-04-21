variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_role_arn" {
  description = "ARN of the EKS cluster IAM role"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "cluster_security_group_id" {
  description = "ID of the EKS cluster security group"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version of the EKS cluster"
  type        = string
}

variable "log_retention_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
  default     = 7
}
