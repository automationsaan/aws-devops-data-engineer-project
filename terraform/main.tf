# Main Terraform configuration for AWS DevOps Data Engineer Project
# This file configures the AWS provider and loads all resources from .tf files in this directory.
# Each major AWS service (VPC, RDS, S3, Glue, Redshift, IAM) is defined in its own .tf file for clarity and modularity.

terraform {
  required_version = ">= 1.3.0"
  # The backend "s3" block is commented out for the initial run.
  # After the S3 bucket for state is created, uncomment this block and reinitialize Terraform to migrate state.
  # backend "s3" {
  #   bucket = "my-terraform-state-bucket"           # Change to your actual S3 bucket for state
  #   key    = "state/aws-data-pipeline.tfstate"
  #   region = "us-east-1"
  # }
}

provider "aws" {
  region = var.aws_region
}

# All resources are defined in their respective .tf files in this directory:
# - vpc.tf:      Networking (VPC, subnets, etc.)
# - rds.tf:      Relational Database Service
# - s3.tf:       S3 buckets for data lake (bronze, silver, etc.)
# - glue.tf:     AWS Glue jobs, crawlers, and catalog
# - redshift.tf: Redshift data warehouse cluster
# - iam.tf:      IAM roles and policies

# No module blocks are needed unless you use actual module directories.
# Terraform will automatically load and apply all resources defined in *.tf files in this directory.

# To add new resources, simply create or edit the appropriate .tf file.

# --- State Migration Instructions ---
# 1. Run 'terraform init' and 'terraform apply' to create all resources, including the S3 state bucket.
# 2. Uncomment the backend "s3" block above and update with your bucket name if needed.
# 3. Run 'terraform init -migrate-state' to migrate local state to S3.
# ------------------------------------
