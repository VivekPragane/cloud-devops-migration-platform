variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "backend_image" {
  description = "ECR image URL for backend"
  type        = string
}

variable "target_group_arn" {
  type = string
}

variable "alb_security_group_id" {
  type = string
}

variable "aws_region" {
  description = "AWS region for CloudWatch logs"
  type        = string
}