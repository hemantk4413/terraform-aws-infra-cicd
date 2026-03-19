output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "vpc_name" {
  description = "VPC Name"
  value       = aws_vpc.main.tags["Name"]
}

output "subnet_id" {
  description = "Public subnet ID"
  value       = aws_subnet.public.id
}
