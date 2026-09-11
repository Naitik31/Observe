# -------------------------------------------------------------------
# VPC Core Settings
# -------------------------------------------------------------------
variable "enable_vpc" {
  description = "Deploy VPC module?"
  type        = bool
}

variable "name" {
  description = "Base name prefix for all resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "create_vpc" {
  description = "Whether to create the VPC"
  type        = bool
  default     = true
}

# -------------------------------------------------------------------
# Subnets
# -------------------------------------------------------------------
variable "create_public_subnets" {
  description = "Whether to create public subnets"
  type        = bool
  default     = true
}

variable "create_private_subnets" {
  description = "Whether to create private subnets"
  type        = bool
  default     = true
}

variable "public_subnet_cidrs" {
  description = "List of CIDRs for public subnets"
  type        = list(string)
  default     = []
}

variable "private_subnet_cidrs" {
  description = "List of CIDRs for private subnets"
  type        = list(string)
  default     = []
}

variable "public_availability_zones" {
  description = "Availability Zones for public subnets"
  type        = list(string)
  default     = []
}

variable "private_availability_zones" {
  description = "Availability Zones for private subnets"
  type        = list(string)
  default     = []
}

# -------------------------------------------------------------------
# Gateways
# -------------------------------------------------------------------
variable "create_internet_gateway" {
  description = "Whether to create an Internet Gateway"
  type        = bool
  default     = true
}

variable "create_nat_gateway" {
  description = "Whether to create a NAT Gateway"
  type        = bool
  default     = true
}

# -------------------------------------------------------------------
# Tags
# -------------------------------------------------------------------
variable "tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default     = {}
}

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
variable "vpc_id" {
  description = "VPC ID"
  type        = string

}

variable "subnet_id" {
  description = "subnet ID"
  type        = string
}

variable "sg_id" {
  description = "sg ID"
  type        = string
}