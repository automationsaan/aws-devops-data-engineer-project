# IAM roles for Glue, Lambda, DMS, and additional services (CodePipeline, Step Functions, MWAA, SageMaker, Firehose, Lake Formation) so these services can run with correct permissions.
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
# CodePipeline Role (for CI/CD automation)
# -------------------------------
resource "aws_iam_role" "codepipeline" {
  name = "codepipeline-role"
  assume_role_policy = data.aws_iam_policy_document.codepipeline_assume_role_policy.json
}

data "aws_iam_policy_document" "codepipeline_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "codepipeline_attach" {
  role       = aws_iam_role.codepipeline.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodePipelineFullAccess"
}

# -------------------------------
# Step Functions Role (for orchestration)
# -------------------------------
resource "aws_iam_role" "step_functions" {
  name = "step-functions-role"
  assume_role_policy = data.aws_iam_policy_document.step_functions_assume_role_policy.json
}

data "aws_iam_policy_document" "step_functions_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["states.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "step_functions_attach" {
  role       = aws_iam_role.step_functions.name
  policy_arn = "arn:aws:iam::aws:policy/AWSStepFunctionsFullAccess"
}

# -------------------------------
# MWAA (Managed Airflow) Execution Role
# -------------------------------
resource "aws_iam_role" "mwaa_execution" {
  name = "mwaa-execution-role"
  assume_role_policy = data.aws_iam_policy_document.mwaa_assume_role_policy.json
}

data "aws_iam_policy_document" "mwaa_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["airflow.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "mwaa_execution_attach" {
  role       = aws_iam_role.mwaa_execution.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonMWAAFullAccess"
}

# -------------------------------
# SageMaker Execution Role
# -------------------------------
resource "aws_iam_role" "sagemaker_execution" {
  name = "sagemaker-execution-role"
  assume_role_policy = data.aws_iam_policy_document.sagemaker_assume_role_policy.json
}

data "aws_iam_policy_document" "sagemaker_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["sagemaker.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "sagemaker_execution_attach" {
  role       = aws_iam_role.sagemaker_execution.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}

# -------------------------------
# Firehose Role (for Kinesis Firehose delivery stream)
# -------------------------------
resource "aws_iam_role" "firehose_role" {
  name = "firehose-delivery-role"
  assume_role_policy = data.aws_iam_policy_document.firehose_assume_role_policy.json
}

data "aws_iam_policy_document" "firehose_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "firehose_attach" {
  role       = aws_iam_role.firehose_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# -------------------------------
# Lake Formation Admin User (optional, for Lake Formation governance)
# -------------------------------
resource "aws_iam_user" "admin" {
  name = "lakeformation-admin"
}

# -------------------------------
# Notes:
# - All new roles and user are added to resolve missing resource errors.
# - Each role is attached to a broad AWS managed policy for demonstration. For production, scope permissions as tightly as possible.
# - Remove or comment out the IAM user if not using Lake Formation admin user.
# - Update S3 bucket ARNs in policies if you change bucket names.
# - Add more permissions as needed for your use case.
