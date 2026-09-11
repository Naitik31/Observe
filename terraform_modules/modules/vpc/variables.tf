# -------------------------------------------------------------------
# General Configuration
# -------------------------------------------------------------------
variable "name" {
  description = "Base name used for all resource naming (e.g. 'prod', 'dev')."
  type        = string
}

variable "tags" {
  description = "Common tags applied to all resources."
  type        = map(string)
  default     = {}
}

# -------------------------------------------------------------------
# VPC
# -------------------------------------------------------------------
variable "create_vpc" {
  description = "Whether to create the VPC."
  type        = bool
  default     = true
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

# -------------------------------------------------------------------
# Availability Zones (Separate for Public & Private)
# -------------------------------------------------------------------

variable "public_availability_zones" {
  description = "List of AZs for public subnets. If empty, AZs will be chosen dynamically."
  type        = list(string)
  default     = []
}

variable "private_availability_zones" {
  description = "List of AZs for private subnets. If empty, AZs will be chosen dynamically."
  type        = list(string)
  default     = []
}

# -------------------------------------------------------------------
# Public Subnets
# -------------------------------------------------------------------
variable "create_public_subnets" {
  description = "Whether to create public subnets."
  type        = bool
  default     = true
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets. If empty, public subnets will not be created."
  type        = list(string)
  default     = []
}

# -------------------------------------------------------------------
# Private Subnets
# -------------------------------------------------------------------
variable "create_private_subnets" {
  description = "Whether to create private subnets."
  type        = bool
  default     = true
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets. If empty, private subnets will not be created."
  type        = list(string)
  default     = []
}

# -------------------------------------------------------------------
# Internet Gateway
# -------------------------------------------------------------------
variable "create_internet_gateway" {
  description = "Whether to create an Internet Gateway and public route table."
  type        = bool
  default     = true
}

# -------------------------------------------------------------------
# NAT Gateway
# -------------------------------------------------------------------
variable "create_nat_gateway" {
  description = "Whether to create a NAT Gateway and private route table."
  type        = bool
  default     = true
}

# -------------------------------------------------------------------
# Elastic IP for NAT Gateway
# -------------------------------------------------------------------
# No CIDR input is needed — this is just a toggle to allow EIP creation
# for NAT when required.
