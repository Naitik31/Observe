output "cluster_name" {
  value = aws_eks_cluster.eks.name
}

output "oidc_issuer" {
  value = aws_eks_cluster.eks.identity[0].oidc[0].issuer
}