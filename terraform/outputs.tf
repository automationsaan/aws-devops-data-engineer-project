# outputs.tf - Defines outputs for important resource attributes
# Outputs make it easy to reference key information after deployment.

# Output the VPC ID created by the VPC module
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

# Output the RDS endpoint for connecting to the database
output "rds_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = module.rds.endpoint
}

# Output the S3 bucket name for data storage
output "s3_bucket" {
  description = "The name of the S3 bucket"
  value       = module.s3.bucket
}

# Output the Redshift cluster endpoint
output "redshift_endpoint" {
  description = "The endpoint of the Redshift cluster"
  value       = module.redshift.endpoint
}

# Output the IAM role ARN for Lambda execution
output "lambda_exec_role_arn" {
  description = "The ARN of the IAM role for Lambda execution"
  value       = module.iam.lambda_exec_role_arn
}

# Notes:
# - These outputs are shown after 'terraform apply' and can be used in other modules or scripts.
# - Add more outputs as needed for your infrastructure.
