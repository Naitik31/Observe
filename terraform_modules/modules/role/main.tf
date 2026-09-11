data "aws_caller_identity" "current" {}

resource "aws_iam_role" "role" {
  for_each = var.roles

  name = each.value.role_name

  assume_role_policy = each.value.assume_oidc_provider ? jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(each.value.oidc_issuer, "https://", "")}"
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${replace(each.value.oidc_issuer, "https://", "")}:sub" = each.value.oidc_sa
        }
      }
    }]
  }) : jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Action    = "sts:AssumeRole"
      Principal = {
        Service = each.value.assume_role_policy.Service
      }
    }]
  })

  tags = var.tags
}


# 🔹 Flatten managed policy attachments (solution to your error)
locals {
  managed_policy_attachments = flatten([
    for role_key, role_data in var.roles : [
      for policy_arn in role_data.managed_policy_arns : {
        role_key   = role_key
        role_name  = role_data.role_name
        policy_arn = policy_arn
      }
    ]
  ])
}

# 🔹 Attach AWS Managed Policies
resource "aws_iam_role_policy_attachment" "managed" {
  for_each = {
    for item in local.managed_policy_attachments :
    "${item.role_key}-${item.policy_arn}" => item
  }

  role       = aws_iam_role.role[each.value.role_key].name
  policy_arn = each.value.policy_arn
}

# 🔹 Inline Custom IAM Policies
resource "aws_iam_policy" "inline" {
  for_each = {
    for k, v in var.roles : k => v
    if v.inline_policy_json != null
  }

  name   = "${each.value.role_name}-inline-policy"
  policy = file(each.value.inline_policy_json)
}

# 🔹 Attach Inline Policies
resource "aws_iam_role_policy_attachment" "inline_attach" {
  for_each = aws_iam_policy.inline

  role       = aws_iam_role.role[each.key].name
  policy_arn = each.value.arn
}