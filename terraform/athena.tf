# athena.tf - Provisions an AWS Athena database for serverless querying of data in S3

# Create an Athena database for querying data stored in S3
# - Athena enables serverless, interactive SQL queries directly on data in S3.
# - This database acts as a logical container for tables and views defined over your S3 data lake.
# - The 'bucket' parameter specifies where Athena stores query results and metadata.
resource "aws_athena_database" "main" {
  name   = "data_lake_db"                # Logical name for the Athena database
  bucket = aws_s3_bucket.silver.bucket   # S3 bucket for Athena query results (typically your "silver" or curated data)
}

# Notes:
# - You can define Athena tables and views using DDL statements referencing this database.
# - Ensure the specified S3 bucket exists and is accessible by Athena.