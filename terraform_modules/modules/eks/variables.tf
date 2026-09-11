variable "name" {
  type        = string
  description = "Base name for EKS resources"
}

variable "eks_version" {
  type        = string
  description = "EKS Kubernetes version"
  default     = "1.30"
}

variable "cluster_role_arn" {
  type        = string
  description = "IAM role ARN for EKS cluster"
}

variable "node_role_arn" {
  type        = string
  description = "IAM role ARN for node group"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs"
}

variable "endpoint_public_access" {
  type    = bool
  default = true
}

variable "desired_size" {
  type    = number
  default = 1
}

variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 2
}

variable "instance_types" {
  type    = list(string)
  default = ["t3.small"]
}

variable "cluster_role_dependencies" {
  type    = list(any)
  default = []
}

variable "node_role_dependencies" {
  type    = list(any)
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "ami_type" {
  type        = string
  description = "Node ami type"
}