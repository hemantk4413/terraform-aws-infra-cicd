variable "instance_type" {
  description = "The type of EC2 instance"
  type        = string
  default     = "t3.micro"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "user_name" {
  description = "IAM user name"
  type        = string
}

variable "group_name" {
  description = "IAM group name"
  type        = string
}

variable "env" {
  description = "Environment name (prod or test)"
  type        = string
  default     = "prod"
}
