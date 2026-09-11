# AWS Provider Configuration

aws_region  = "us-west-2"
access_key  = ""
secret_key  = ""
# VPC Settings

name     = "k8s-obs"
vpc_cidr = "10.0.0.0/24"
# Feature Toggles
create_vpc              = true
create_public_subnets   = true
create_private_subnets  = true
create_internet_gateway = true
create_nat_gateway      = true
# Subnet Configuration
# public_subnet_cidrs  = ["10.0.0.0/26"]
public_subnet_cidrs = ["10.0.0.0/26", "10.0.0.64/26"]
private_subnet_cidrs = ["10.0.0.128/26", "10.0.0.192/26"]
public_availability_zones  = []
private_availability_zones = []

# Tags

tags = {
  Environment = "dev"
  Owner       = "naitik"
}

# ------------------------------------------------------------------
# role configuration
# ------------------------------------------------------------------
roles = {
  eks_cluster_role = {
    role_name = "eks-dev-cluster-role"
    assume_role_policy = {
      Service = "eks.amazonaws.com"
      Action  = "sts:AssumeRole"
    }
    managed_policy_arns = [
      "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
      "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
    ]
    inline_policy_json = null
  }
  
  eks_nodegroup_role = {
    role_name = "eks-dev-nodegroup-role"
    assume_role_policy = {
      Service = "ec2.amazonaws.com"
      Action  = "sts:AssumeRole"
    }
    managed_policy_arns = [
      "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
      "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
      "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    ]
    inline_policy_json = null
  }
}

alb_controller_role = {
  role_name   = "aws-load-balancer-controller-role"
  oidc_sa     = "system:serviceaccount:kube-system:aws-load-balancer-controller"
  managed_policy_arns = []
  inline_policy_json = "./policies/alb_controller_policy.json"
}
#-------------------------------------------------------------------
# eks vars
#-------------------------------------------------------------------
# name = "dev"
eks_version = "1.34"

eks_instance_types = ["t3.small"]
ami_type       = "AL2023_x86_64_STANDARD"
desired_size   = 2
min_size       = 2
max_size       = 2


#-------------------------------------------------------------------
# Common Tags
#-------------------------------------------------------------------
enable_vpc   = true
enable_role   = true
enable_eks    = true
enable_alb_iam_role = true

vpc_id = ""
subnet_id = ""
sg_id   = ""
private_subnet_ids = []