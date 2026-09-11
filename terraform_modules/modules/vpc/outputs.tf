output "vpc_id" {
  description = "The ID of the VPC."
  value       = try(aws_vpc.main[0].id, null)
}

output "public_subnet_ids" {
  description = "List of IDs for public subnets."
  value       = [for s in aws_subnet.public : s.id]
}

output "private_subnet_ids" {
  description = "List of IDs for private subnets."
  value       = [for s in aws_subnet.private : s.id]
}

output "igw_id" {
  description = "Internet Gateway ID."
  value       = try(aws_internet_gateway.igw[0].id, null)
}

output "nat_gateway_id" {
  description = "NAT Gateway ID."
  value       = try(aws_nat_gateway.ngw[0].id, null)
}

output "public_route_table_id" {
  description = "Public route table ID."
  value       = try(aws_route_table.public_rt[0].id, null)
}

output "private_route_table_id" {
  description = "Private route table ID."
  value       = try(aws_route_table.private_rt[0].id, null)
}