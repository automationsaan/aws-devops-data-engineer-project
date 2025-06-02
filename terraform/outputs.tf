# outputs.tf - Defines outputs for important resource attributes
# Outputs make it easy to reference key information after deployment.

# Output the VPC ID created by the VPC resource
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

# Output the RDS endpoint for connecting to the database
output "rds_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = aws_db_instance.mysql.endpoint
}

# Output the Bronze S3 bucket name for data storage
output "s3_bucket_bronze" {
  description = "The name of the Bronze S3 bucket"
  value       = aws_s3_bucket.bronze.bucket
}

# Output the Silver S3 bucket name for data storage
output "s3_bucket_silver" {
  description = "The name of the Silver S3 bucket"
  value       = aws_s3_bucket.silver.bucket
}

# Output the Redshift cluster endpoint
output "redshift_endpoint" {
  description = "The endpoint of the Redshift cluster"
  value       = aws_redshift_cluster.main.endpoint
}

# Output the IAM role ARN for Lambda execution
output "lambda_exec_role_arn" {
  description = "The ARN of the IAM role for Lambda execution"
  value       = aws_iam_role.lambda_execution.arn
}

# Notes:
# - These outputs are shown after 'terraform apply' and can be used in other modules or scripts.
# - Update resource names if your actual resource blocks use different names.
# - Add more outputs as needed for your infrastructure.
