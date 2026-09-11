module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # Set to false in production and access via VPN/bastion/private endpoint instead
  cluster_endpoint_public_access = true

  # Core add-ons managed by AWS (CNI, kube-proxy, CoreDNS, EBS CSI driver)
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent = true
    }
  }

  eks_managed_node_group_defaults = {
    ami_type = "AL2023_x86_64_STANDARD"
  }

  eks_managed_node_groups = {
    default = {
      min_size       = var.node_min_size
      max_size       = var.node_max_size
      desired_size   = var.node_desired_size
      instance_types = var.node_instance_types
      capacity_type  = var.node_capacity_type

      labels = {
        role = "general"
      }
    }
  }

  # Grants the IAM identity running `terraform apply` cluster-admin access
  enable_cluster_creator_admin_permissions = true

  tags = var.tags
}
