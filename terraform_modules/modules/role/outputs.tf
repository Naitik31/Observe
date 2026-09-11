output "role_arns" {
  description = "Map of role keys to their IAM Role ARNs"
  value = {
    for k, v in aws_iam_role.role :
    k => v.arn
  }
}