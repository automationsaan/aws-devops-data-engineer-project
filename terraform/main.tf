# This Terraform configuration sets up an AWS Data Pipeline with a simple S3 copy activity.
# It includes the necessary provider configuration and backend settings.

# Set aws provider and backend configuration
provider "aws" {
  region = var.aws_region
}

terraform {
  required_version = ">= 1.3.0"

# Configure the backend to store the Terraform state in an S3 bucket
  backend "s3" {
    bucket = "my-terraform-state-bucket"
    key    = "state/aws-data-pipeline.tfstate"
    region = "us-east-1"
  }
}

# main.tf - Main entry point for Terraform configuration
# This file configures the AWS provider and includes all major infrastructure modules.

# Configure the AWS provider
provider "aws" {
  region = var.aws_region  # Use the region specified in variables.tf
}

# VPC module or resource - sets up networking for your AWS resources
module "vpc" {
  source = "./vpc.tf"  # Reference to your VPC configuration file
}

# RDS module or resource - sets up a managed relational database
module "rds" {
  source = "./rds.tf"
}

# S3 module or resource - sets up object storage for data and artifacts
module "s3" {
  source = "./s3.tf"
}

# Glue module or resource - sets up AWS Glue for ETL jobs
module "glue" {
  source = "./glue.tf"
}

# Redshift module or resource - sets up a data warehouse cluster
module "redshift" {
  source = "./redshift.tf"
}

# IAM module or resource - sets up roles and permissions for your services
module "iam" {
  source = "./iam.tf"
}

# Notes:
# - Each module points to a separate .tf file for modularity and clarity.
# - You can replace 'module' with 'resource' blocks if you are not using modules.
# - This structure makes it easy to manage and scale your AWS infrastructure.
