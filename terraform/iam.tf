# IAM roles for Glue, Lambda, and DMS so these services can run with correct permissions.
# Each role has a trust policy allowing the respective AWS service to assume it.
# Managed and custom policies are attached to grant the necessary permissions.

# -------------------------------
# Glue Service Role
# -------------------------------
resource "aws_iam_role" "glue_role" {
  name = "glue-service-role"

  # Trust policy: allows AWS Glue to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Principal = {
        Service = "glue.amazonaws.com"
      }
      Effect = "Allow"
    }]
  })
}

# Attach AWS managed Glue policy for basic Glue permissions
resource "aws_iam_policy_attachment" "glue_attach" {
  name       = "glue-policy-attach"
  roles      = [aws_iam_role.glue_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

# -------------------------------
# Lambda Execution Role
# -------------------------------
resource "aws_iam_role" "lambda_execution" {
  name = "lambda-execution-role"

  # Trust policy: allows AWS Lambda to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# Custom policy for Lambda: S3 read/write and CloudWatch Logs
resource "aws_iam_policy" "lambda_custom_policy" {
  name        = "lambda-s3-logs-policy"
  description = "Allow Lambda to access S3 buckets and write logs to CloudWatch"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::data-pipeline-bronze-bucket",
          "arn:aws:s3:::data-pipeline-bronze-bucket/*",
          "arn:aws:s3:::data-pipeline-silver-bucket",
          "arn:aws:s3:::data-pipeline-silver-bucket/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# Attach AWS managed basic execution policy (for CloudWatch logging)
resource "aws_iam_policy_attachment" "lambda_basic_execution" {
  name       = "lambda-basic-execution-attach"
  roles      = [aws_iam_role.lambda_execution.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Attach custom policy to Lambda role
resource "aws_iam_policy_attachment" "lambda_custom_policy_attach" {
  name       = "lambda-custom-policy-attach"
  roles      = [aws_iam_role.lambda_execution.name]
  policy_arn = aws_iam_policy.lambda_custom_policy.arn
}

# -------------------------------
# DMS Service Role
# -------------------------------
resource "aws_iam_role" "dms_role" {
  name = "dms-vpc-role"

  # Trust policy: allows AWS DMS to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "dms.amazonaws.com"
      }
    }]
  })
}

# Attach AWS managed DMS VPC management policy
resource "aws_iam_policy_attachment" "dms_attach" {
  name       = "dms-policy-attach"
  roles      = [aws_iam_role.dms_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonDMSVPCManagementRole"
}

# -------------------------------
# Notes:
# - Each role is created with a trust policy for its service.
# - Managed policies are attached for Glue and DMS.
# - Lambda gets both a managed policy (basic execution) and a custom policy for S3 and CloudWatch Logs.
# - Update S3 bucket ARNs if you change bucket names.
# - Add more permissions as needed for your use case.
