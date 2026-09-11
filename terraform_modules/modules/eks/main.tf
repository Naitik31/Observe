resource "aws_eks_cluster" "eks" {
  name     = "${var.name}-eks-cluster"
  version  = var.eks_version
  role_arn = var.cluster_role_arn

  vpc_config {
    subnet_ids             = var.private_subnet_ids
    endpoint_public_access = var.endpoint_public_access
  }

  tags = var.tags
}

resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "${var.name}-node-group"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.private_subnet_ids
  ami_type        = var.ami_type

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  instance_types = var.instance_types
  tags           = var.tags
}