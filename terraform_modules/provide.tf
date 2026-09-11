terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Optional — use remote backend for team environments
  # backend "s3" {
  #   bucket         = "my-terraform-states"
  #   key            = "vpc/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "terraform-locks"
  #   encrypt        = true
  # }
}

provider "aws" {
  region  = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}


# -------------------------------------------------------------------
# AWS Provider
# -------------------------------------------------------------------
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "access_key" {
  description = "AWS Access Key"
  type        = string
  sensitive   = true
}

variable "secret_key" {
  description = "AWS Secret Key"
  type        = string
  sensitive   = true
}