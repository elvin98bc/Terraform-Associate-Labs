variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "main_vpc_id" {
  description = "default VPC ID"
  type        = string
  default     = "vpc-028d38da7adc5c214"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.nano"
}

variable "keypair_name" {
  description = "keypair name"
  type        = string
  default     = "mynewkeypair"
}

variable "user_data" {
  description = "Path to user data bash script file"
  type        = string
  default     = "userdata.sh"
}