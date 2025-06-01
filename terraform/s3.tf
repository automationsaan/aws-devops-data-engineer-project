# S3 Buckets created for Bronze and Silver stages of the data pipeline
# These buckets are used to store data at different stages of processing in your pipeline.
# "Bronze" is typically raw or ingested data, "Silver" is cleaned or transformed data.

# Create the Bronze stage S3 bucket for raw/ingested data
resource "aws_s3_bucket" "bronze" {
  bucket        = "data-pipeline-bronze-bucket"  # Unique bucket name for the bronze stage
  force_destroy = true                           # Allows bucket to be destroyed even if not empty (useful for dev/test)

  tags = {
    Stage = "bronze"                             # Tag to identify the stage
    Environment = "dev"
  }
}

# Create the Silver stage S3 bucket for cleaned/transformed data
resource "aws_s3_bucket" "silver" {
  bucket        = "data-pipeline-silver-bucket"  # Unique bucket name for the silver stage
  force_destroy = true                           # Allows bucket to be destroyed even if not empty

  tags = {
    Stage = "silver"                             # Tag to identify the stage
    Environment = "dev"
  }
}

# Notes:
# - Each bucket is tagged with its stage for easy identification and management.
# - Use force_destroy with caution in production to avoid accidental data loss.
# - You can add versioning, encryption, or public access blocks as needed for security and compliance.