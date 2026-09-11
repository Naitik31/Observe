module "vpc" {
  count = var.enable_vpc ? 1 : 0
  source = "./modules/vpc"
  name                       = var.name
  vpc_cidr                   = var.vpc_cidr
  create_vpc                 = var.create_vpc
  create_public_subnets      = var.create_public_subnets
  create_private_subnets     = var.create_private_subnets
  create_internet_gateway    = var.create_internet_gateway
  create_nat_gateway         = var.create_nat_gateway
  public_subnet_cidrs        = var.public_subnet_cidrs
  private_subnet_cidrs       = var.private_subnet_cidrs
  public_availability_zones  = var.public_availability_zones
  private_availability_zones = var.private_availability_zones
  tags                       = var.tags
}
###########################################################################
module "iam_roles" {
  count = var.enable_role ? 1 : 0
  source = "./modules/role"
  roles = var.roles
  tags  = var.tags
}
###########################################################################
module "eks" {
  count = var.enable_eks ? 1 : 0
  source = "./modules/eks"
  name        = var.name
  eks_version = var.eks_version
  private_subnet_ids = var.enable_vpc ? try(module.vpc[0].private_subnet_ids, []) : var.private_subnet_ids
  cluster_role_arn = module.iam_roles[0].role_arns["eks_cluster_role"]
  node_role_arn    = module.iam_roles[0].role_arns["eks_nodegroup_role"]
  instance_types = var.eks_instance_types
  ami_type       = var.ami_type
  desired_size   = var.desired_size
  min_size       = var.min_size
  max_size       = var.max_size
  tags = var.tags
  depends_on = [module.iam_roles]
}
############################################################################
# data "aws_eks_cluster" "eks" {
#   name = module.eks[0].cluster_name
# }

locals {
  alb_role = var.enable_alb_iam_role ? {
    alb_controller_role = {
      role_name            = var.alb_controller_role.role_name
      assume_oidc_provider = true
      oidc_issuer          = module.eks[0].oidc_issuer
      oidc_sa              = var.alb_controller_role.oidc_sa
      managed_policy_arns  = var.alb_controller_role.managed_policy_arns
      inline_policy_json   = var.alb_controller_role.inline_policy_json
    }
  } : {}
}

module "alb_iam_role" {
  count  = var.enable_alb_iam_role ? 1 : 0
  source = "./modules/role"
  roles  = local.alb_role
  tags   = var.tags

  depends_on = [module.eks]
}

###########################################################################
