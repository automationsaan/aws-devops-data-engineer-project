# variables.tf - Defines input variables for Terraform modules and resources
# Variables make your Terraform configuration flexible and reusable.

# AWS region to deploy resources in
variable "aws_region" {
  description = "The AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

# VPC CIDR block
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# RDS database instance class
variable "rds_instance_class" {
  description = "Instance type for RDS database"
  type        = string
  default     = "db.t3.micro"
}

# S3 bucket name for data storage
variable "s3_bucket_name" {
  description = "Name of the S3 bucket for storing data"
  type        = string
  default     = "my-data-bucket"
}

# Redshift cluster identifier
variable "redshift_cluster_identifier" {
  description = "Identifier for the Redshift cluster"
  type        = string
  default     = "redshift-cluster-1"
}

# IAM role name for Lambda execution
variable "lambda_exec_role_name" {
  description = "Name of the IAM role for Lambda execution"
  type        = string
  default     = "lambda_exec_role"
}

# Notes:
# - You can override these defaults using a terraform.tfvars file or CLI arguments.
# - Add more variables as needed for your infrastructure.
