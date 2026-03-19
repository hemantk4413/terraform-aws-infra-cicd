output "instance_id" {
  description = "EC2 instance ID"
  value       = module.ec2_instance.instance_id
}

output "public_ip" {
  description = "EC2 public IP"
  value       = module.ec2_instance.public_ip
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "vpc_name" {
  description = "VPC Name"
  value       = module.vpc.vpc_name
}

output "subnet_id" {
  description = "Public subnet ID"
  value       = module.vpc.subnet_id
}
output "user_name" {
  value = module.terraform_user.user_name
}
output "s3bucket_name1" {
  value = module.demo_bucket.bucket_name

}
output "New-group" {
  value = module.terraform_user.group_name
}