# monitoring.tf - Defines monitoring and auditing resources for the data pipeline

# Create a CloudWatch Log Group for centralized logging
# This log group can be used by Lambda functions, ECS tasks, or other AWS services to store logs for monitoring and troubleshooting.
resource "aws_cloudwatch_log_group" "main" {
  name = "/aws/data-pipeline" # Log group name for organizing pipeline logs
}

# Create a CloudTrail trail for auditing API activity across your AWS account
# CloudTrail records all API calls and delivers logs to the specified S3 bucket for auditing and compliance.
resource "aws_cloudtrail" "main" {
  name                          = "pipeline-trail"                # Unique name for the CloudTrail trail
  s3_bucket_name                = aws_s3_bucket.bronze.bucket     # S3 bucket to store CloudTrail logs
  include_global_service_events = true                            # Capture events from global AWS services (e.g., IAM)
}

# Notes:
# - CloudWatch Log Groups help centralize and retain logs for analysis and alerting.
# - CloudTrail provides a complete audit trail of all API activity, supporting security and compliance requirements.
# - Storing CloudTrail logs in S3 enables long-term retention and integration with other analytics tools.