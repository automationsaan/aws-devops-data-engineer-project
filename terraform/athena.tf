# athena.tf - Provisions AWS Athena databases for serverless querying of data in S3
# This file demonstrates the medallion architecture by creating Athena databases for bronze, silver, and gold layers.

# ---------------------------------------------------------------------------
# Athena Database for Bronze Layer (Raw/Ingested Data)
# ---------------------------------------------------------------------------
resource "aws_athena_database" "bronze" {
  name   = "bronze_data_lake_db"                # Logical name for the Athena database (bronze layer)
  bucket = aws_s3_bucket.bronze.bucket          # S3 bucket for Athena query results (bronze/raw data)
}

# ---------------------------------------------------------------------------
# Athena Database for Silver Layer (Cleaned/Transformed Data)
# ---------------------------------------------------------------------------
resource "aws_athena_database" "silver" {
  name   = "silver_data_lake_db"                # Logical name for the Athena database (silver layer)
  bucket = aws_s3_bucket.silver.bucket          # S3 bucket for Athena query results (silver/curated data)
}

# ---------------------------------------------------------------------------
# Athena Database for Gold Layer (Analytics-Ready/Business-Level Data)
# ---------------------------------------------------------------------------
resource "aws_athena_database" "gold" {
  name   = "gold_data_lake_db"                  # Logical name for the Athena database (gold layer)
  bucket = aws_s3_bucket.gold.bucket            # S3 bucket for Athena query results (gold/analytics-ready data)
}

# ---------------------------------------------------------------------------
# Notes:
# - Each Athena database is mapped to a different S3 bucket representing a medallion layer.
# - This enables serverless, interactive SQL queries directly on raw (bronze), curated (silver), and analytics-ready (gold) data.
# - You can define Athena tables and views using DDL statements referencing these databases.
# - Ensure the specified S3 buckets exist and are accessible by Athena.
# - This setup provides full medallion architecture support for your data lake.