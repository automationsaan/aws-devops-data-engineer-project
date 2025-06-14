# monitoring.tf - Defines monitoring and auditing resources for the data pipeline
# This version supports the full medallion architecture by enabling monitoring and auditing for bronze, silver, and gold S3 buckets.

# ---------------------------------------------------------------------------
# CloudWatch Log Group for Centralized Logging
# ---------------------------------------------------------------------------
# This log group can be used by Lambda functions, Glue jobs, or other AWS services to store logs for monitoring and troubleshooting.
resource "aws_cloudwatch_log_group" "main" {
  name = "/aws/data-pipeline" # Log group name for organizing pipeline logs
}

# ---------------------------------------------------------------------------
# CloudTrail Trails for Auditing API Activity Across All Medallion Layers
# ---------------------------------------------------------------------------
# CloudTrail records all API calls and delivers logs to the specified S3 bucket for auditing and compliance.
# Here, we create a separate trail for each medallion layer (bronze, silver, gold) to enable granular auditing and retention.

# CloudTrail for Bronze Layer
resource "aws_cloudtrail" "bronze" {
  name                          = "pipeline-trail-bronze"                # Unique name for the CloudTrail trail
  s3_bucket_name                = aws_s3_bucket.bronze.bucket            # S3 bucket to store CloudTrail logs for bronze
  include_global_service_events = true                                   # Capture events from global AWS services (e.g., IAM)
}

# CloudTrail for Silver Layer
resource "aws_cloudtrail" "silver" {
  name                          = "pipeline-trail-silver"
  s3_bucket_name                = aws_s3_bucket.silver.bucket            # S3 bucket to store CloudTrail logs for silver
  include_global_service_events = true
}

# CloudTrail for Gold Layer
resource "aws_cloudtrail" "gold" {
  name                          = "pipeline-trail-gold"
  s3_bucket_name                = aws_s3_bucket.gold.bucket              # S3 bucket to store CloudTrail logs for gold
  include_global_service_events = true
}

# ---------------------------------------------------------------------------
# Notes:
# - CloudWatch Log Groups help centralize and retain logs for analysis and alerting.
# - CloudTrail provides a complete audit trail of all API activity, supporting security and compliance requirements.
# - Creating separate CloudTrail trails for each medallion layer enables granular monitoring and retention policies.
# - Storing CloudTrail logs in S3 enables long-term retention and integration with other analytics tools.
# - Adjust retention, encryption, and access policies as needed for your organization's requirements.