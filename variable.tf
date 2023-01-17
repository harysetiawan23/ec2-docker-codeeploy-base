variable "app_name" {
  description = "Application Name"
  type        = string
}

variable "vpc_id" {
  description = "AWS VPC ID"
  type        = string
}

variable "environment" {
  description = "Deployment stage [staging,uat,prod]"
  default     = "test"
  type        = string
}

variable "subnet_id" {
  description = "AWS Subnet ID"
  type        = string
}

variable "key_name" {
  description = "Key Name for EC2"
  type        = string
}
