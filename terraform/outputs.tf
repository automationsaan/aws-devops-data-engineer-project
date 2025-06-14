# outputs.tf - Defines outputs for important resource attributes
# Outputs make it easy to reference key information after deployment.
# These outputs can be used by automation scripts, other Terraform modules, or for manual reference.

# Output the VPC ID created by the VPC resource
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

# Output the IDs of the public subnets
output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = [for subnet in aws_subnet.public : subnet.id]
}

# Output the endpoint of the RDS MySQL instance
output "mysql_endpoint" {
  description = "The endpoint of the RDS MySQL instance"
  value       = aws_db_instance.mysql.endpoint
}

# Output the endpoint of the Redshift cluster
output "redshift_endpoint" {
  description = "The endpoint of the Redshift cluster"
  value       = aws_redshift_cluster.main.endpoint
}

# Output the ARN of the DMS replication task
output "dms_task_arn" {
  description = "The ARN of the DMS replication task"
  value       = aws_dms_replication_task.main.replication_task_arn
}

# Output the S3 bucket name for the bronze layer
output "bronze_bucket" {
  description = "The name of the S3 bucket for the bronze data lake layer"
  value       = aws_s3_bucket.bronze.bucket
}

# Output the S3 bucket name for the silver layer
output "silver_bucket" {
  description = "The name of the S3 bucket for the silver data lake layer"
  value       = aws_s3_bucket.silver.bucket
}

# Output the S3 bucket name for the gold layer
output "gold_bucket" {
  description = "The name of the S3 bucket for the gold data lake layer"
  value       = aws_s3_bucket.gold.bucket
}

# Output the IAM role ARN for Glue
output "glue_role_arn" {
  description = "The ARN of the IAM role for AWS Glue"
  value       = aws_iam_role.glue_role.arn
}

# Output the IAM role ARN for Lambda
output "lambda_role_arn" {
  description = "The ARN of the IAM role for AWS Lambda"
  value       = aws_iam_role.lambda_execution.arn
}

# Output the IAM role ARN for DMS
output "dms_role_arn" {
  description = "The ARN of the IAM role for AWS DMS"
  value       = aws_iam_role.dms_role.arn
}

# Output the IAM role ARN for CodePipeline
output "codepipeline_role_arn" {
  description = "The ARN of the IAM role for CodePipeline"
  value       = aws_iam_role.codepipeline.arn
}

# Output the IAM role ARN for Step Functions
output "step_functions_role_arn" {
  description = "The ARN of the IAM role for Step Functions"
  value       = aws_iam_role.step_functions.arn
}

# Output the IAM role ARN for MWAA
output "mwaa_execution_role_arn" {
  description = "The ARN of the IAM role for MWAA (Managed Airflow)"
  value       = aws_iam_role.mwaa_execution.arn
}

# Output the IAM role ARN for SageMaker
output "sagemaker_execution_role_arn" {
  description = "The ARN of the IAM role for SageMaker"
  value       = aws_iam_role.sagemaker_execution.arn
}

# Output the IAM role ARN for Firehose
output "firehose_role_arn" {
  description = "The ARN of the IAM role for Kinesis Firehose"
  value       = aws_iam_role.firehose_role.arn
}

# Notes:
# - These outputs make it easy to retrieve important resource identifiers after deployment.
# - You can use `terraform output` or `terraform output -json` to access these values for automation or debugging.
# - Add more outputs as needed for your infrastructure.
# - The bronze, silver, and gold outputs support the full data lake architecture.
