# S3 Buckets for Bronze, Silver, and Gold stages of the data pipeline
# These buckets represent the medallion architecture:
# - Bronze: Raw/ingested data
# - Silver: Cleaned/transformed data
# - Gold: Analytics-ready/business-level data

# ---------------------------------------------------------------------------
# Bronze Stage S3 Bucket (Raw/Ingested Data)
# ---------------------------------------------------------------------------
resource "aws_s3_bucket" "bronze" {
  bucket        = "data-pipeline-bronze-bucket"  # Unique bucket name for the bronze stage
  force_destroy = true                           # Allows bucket to be destroyed even if not empty (useful for dev/test)

  tags = {
    Stage       = "bronze"                       # Tag to identify the stage
    Environment = "dev"
  }
}

# ---------------------------------------------------------------------------
# Silver Stage S3 Bucket (Cleaned/Transformed Data)
# ---------------------------------------------------------------------------
resource "aws_s3_bucket" "silver" {
  bucket        = "data-pipeline-silver-bucket"  # Unique bucket name for the silver stage
  force_destroy = true                           # Allows bucket to be destroyed even if not empty

  tags = {
    Stage       = "silver"                       # Tag to identify the stage
    Environment = "dev"
  }
}

# ---------------------------------------------------------------------------
# Gold Stage S3 Bucket (Analytics-Ready/Business-Level Data)
# ---------------------------------------------------------------------------
resource "aws_s3_bucket" "gold" {
  bucket        = "data-pipeline-gold-bucket"    # Unique bucket name for the gold stage
  force_destroy = true                           # Allows bucket to be destroyed even if not empty

  tags = {
    Stage       = "gold"                         # Tag to identify the stage
    Environment = "dev"
  }
}

# ---------------------------------------------------------------------------
# Notes:
# - Each bucket is tagged with its stage for easy identification and management.
# - The gold bucket completes the medallion architecture (bronze → silver → gold).
# - Use force_destroy with caution in production to avoid accidental data loss.
# - You can add versioning, encryption, or public access blocks as needed for security and compliance.