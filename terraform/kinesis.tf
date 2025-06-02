# kinesis.tf - Defines streaming data ingestion resources using Amazon Kinesis

# Create a Kinesis Data Stream for real-time data ingestion
# This stream can be used for ingesting streaming data (e.g., logs, events, IoT data) into the pipeline.
resource "aws_kinesis_stream" "input_stream" {
  name             = "data-pipeline-stream" # Unique name for the Kinesis stream
  shard_count      = 1                      # Number of shards (parallelism/throughput units)
  retention_period = 24                     # Data retention in hours (default is 24)
}

# Create a Kinesis Firehose Delivery Stream to deliver streaming data to S3
# Firehose automatically batches, compresses, and delivers data from the stream to the specified S3 bucket.
resource "aws_kinesis_firehose_delivery_stream" "to_s3" {
  name        = "firehose-to-s3"            # Unique name for the Firehose delivery stream
  destination = "s3"                        # Destination is S3

  s3_configuration {
    role_arn   = aws_iam_role.firehose_role.arn # IAM role that Firehose assumes to write to S3
    bucket_arn = aws_s3_bucket.bronze.arn       # Target S3 bucket for raw/bronze data
  }
}

# Notes:
# - The Kinesis stream enables real-time ingestion and processing of data.
# - Firehose simplifies loading streaming data into S3 for further ETL or analytics.
# - Ensure the IAM role (firehose_role) has the necessary permissions to write to the S3 bucket.