# ---------------------------
# General Inputs
# ---------------------------
# variable "name" {
#   description = "Base name tag for EKS resources"
#   type        = string
# }

variable "eks_version" {
  description = "Kubernetes version for EKS cluster"
  type        = string
  default     = "1.30"
}

# variable "tags" {
#   description = "Common resource tags"
#   type        = map(string)
#   default     = {}
# }

# ---------------------------
# EKS IAM Role Inputs
# ---------------------------

# ---------------------------
# EKS Networking Inputs
# ---------------------------

variable "endpoint_public_access" {
  description = "Expose EKS endpoint publicly"
  type        = bool
  default     = true
}

# ---------------------------
# Node Group Settings
# ---------------------------
variable "instance_types" {
  description = "EC2 instance types for EKS worker nodes"
  type        = list(string)
  default     = ["t3.small"]
}

variable "desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 1
}

variable "min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 2
}

# ---------------------------
# Dependency Variables
# ---------------------------
variable "cluster_role_dependencies" {
  description = "IAM role policy attachments required before EKS cluster creation"
  type        = list(any)
  default     = []
}

variable "node_role_dependencies" {
  description = "IAM role policy attachments required before EKS node group creation"
  type        = list(any)
  default     = []
}

variable "eks_instance_types" {
  type    = list(string)
  default = ["t3.small"]
}

variable "enable_eks" {
  type    = bool
  default = false
  description = "Enable creation of EKS cluster and node group"
}

variable "private_subnet_ids" {
  type        = list(string)
  default     = []
  description = "Private subnet IDs when not creating VPC"
}

variable "ami_type" {
  description = "node ami_type "
  type        = string
  default     = "AL2023_x86_64_STANDARD"
}