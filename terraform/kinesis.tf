# kinesis.tf - Defines streaming data ingestion resources using Amazon Kinesis

# Create a Kinesis Data Stream for real-time data ingestion
resource "aws_kinesis_stream" "main" {
  name             = "data-pipeline-stream" # Unique name for the Kinesis stream
  shard_count      = 1                      # Number of shards (parallelism/throughput units)
  retention_period = 24                     # Data retention in hours (default is 24)

  tags = {
    Environment = "dev"
    Name        = "data-pipeline-stream"
  }
}

# Create a Kinesis Firehose delivery stream to ingest data into S3
# - Uses extended_s3_configuration as required by the latest AWS provider
# - Ensure the IAM role (firehose_role) has the necessary permissions to write to the S3 bucket
resource "aws_kinesis_firehose_delivery_stream" "to_s3" {
  name        = "firehose-to-s3"            # Unique name for the Firehose delivery stream
  destination = "extended_s3"               # Use extended_s3 for modern Firehose config

  extended_s3_configuration {
    role_arn   = aws_iam_role.firehose_role.arn # IAM role that Firehose assumes to write to S3
    bucket_arn = aws_s3_bucket.bronze.arn       # Target S3 bucket for raw/bronze data

    # Optional: Customize buffer, compression, and prefix settings as needed
    # prefix              = "firehose-data/"
    # buffer_size         = 5
    # buffer_interval     = 300
    # compression_format  = "UNCOMPRESSED"
  }
}

# Notes:
# - This resource enables streaming data ingestion from Kinesis Firehose directly into your S3 data lake.
# - Adjust buffer, compression, and prefix settings in extended_s3_configuration as needed for your use case.
# - The IAM role (firehose_role) must have permissions for PutObject on the target S3 bucket.