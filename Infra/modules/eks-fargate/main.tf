resource "aws_eks_cluster" "fargate" {
  name    = var.cluster_name
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

resource "aws_iam_policy" "eks_cluster_policy" {
  name_prefix = "${var.cluster_name}-cluster-policy"
  policy = jsonencode({
    Statement = [{
      Action = [
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:CreateSecurityGroup",
        "ec2:DeleteSecurityGroup",
        "ec2:DescribeAccountAttributes",
        "ec2:DescribeAddresses",
        "ec2:DescribeAvailabilityZones",
        "ec2:DescribeInternetGateways",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DescribePrefixLists",
        "ec2:DescribeRouteTables",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeSubnets",
        "ec2:DescribeVpcs",
        "ec2:ModifyNetworkInterfaceAttribute",
        "ec2:RevokeSecurityGroupIngress",
        "eks:CreateCluster",
        "eks:DeleteCluster",
        "eks:DescribeCluster",
        "eks:ListClusters",
        "eks:UpdateClusterConfig",
        "eks:UpdateClusterVersion",
        "iam:PassRole",
        "kms:Connect",
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams",
        "logs:PutLogEvents",
        "rds:DescribeDBClusters",
        "rds:DescribeDBInstances",
        "route53:ChangeResourceRecordSets",
        "route53:CreateHostedZone",
        "route53:DeleteHostedZone",
        "route53:GetChange",
        "route53:ListHostedZones",
        "route53:ListResourceRecordSets",
        "s3:GetBucketPolicy",
        "s3:ListBucket",
        "s3:PutBucketPolicy",
        "ssm:GetParameter",
        "sts:AssumeRole",
      ],
      Effect   = "Allow"
      Resource = "*"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = aws_iam_policy.eks_cluster_policy.arn
  role = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "eks_vpc_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role = aws_iam_role.eks_cluster_role.name
}


resource "aws_eks_fargate_profile" "default" {
  cluster_name           = aws_eks_cluster.fargate.name
  name_prefix            = "fp"
  pod_execution_role_arn = aws_iam_role.eks_fargate_pod_execution_role.arn
  subnet_ids = [
    var.private_subnet_1_id,
    var.private_subnet_2_id,
  ]

  selector {
    namespace = "default"
  }

  selector {
    namespace = "kube-system"
  }
}

resource "aws_iam_role" "eks_fargate_pod_execution_role" {
  name_prefix = "${var.cluster_name}-fargate-pod-execution-role"
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks-fargate-pods.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_policy" "eks_fargate_pod_execution_policy" {
  name_prefix = "${var.cluster_name}-fargate-pod-execution-policy"
  policy = jsonencode({
    Statement = [{
      Action = [
        "ec2:CreateNetworkInterface",
        "ec2:DeleteNetworkInterface",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DetachNetworkInterface",
        "ec2:ModifyNetworkInterfaceAttribute",
        "ec2:AssignPrivateIpAddresses",
        "ec2:UnassignPrivateIpAddresses",
      ],
      Effect   = "Allow"
      Resource = "*"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "eks_fargate_pod_execution_policy" {
  policy_arn = aws_iam_policy.eks_fargate_pod_execution_policy.arn
  role = aws_iam_role.eks_fargate_pod_execution_role.name
}
