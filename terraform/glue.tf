# AWS Glue resources for ETL (Extract, Transform, Load) in the data pipeline.
# This file creates Glue databases, crawlers, and jobs for the bronze, silver, and gold layers,
# supporting a full medallion architecture.

# -------------------------------
# Glue Databases for Medallion Layers
# -------------------------------
resource "aws_glue_catalog_database" "bronze_db" {
  name        = "bronze_db"
  description = "Glue database for raw/bronze stage data"
}

resource "aws_glue_catalog_database" "silver_db" {
  name        = "silver_db"
  description = "Glue database for cleaned/silver stage data"
}

resource "aws_glue_catalog_database" "gold_db" {
  name        = "gold_db"
  description = "Glue database for analytics-ready/gold stage data"
}

# -------------------------------
# Glue Crawlers for Each Layer
# -------------------------------

# Crawler for Bronze Layer (discovers schema in raw data)
resource "aws_glue_crawler" "bronze_crawler" {
  name          = "bronze-crawler"
  role          = aws_iam_role.glue_role.arn
  database_name = aws_glue_catalog_database.bronze_db.name

  s3_target {
    path = "s3://${aws_s3_bucket.bronze.bucket}/"
  }

  schedule = "cron(0 0 * * ? *)" # Daily at midnight UTC
}

# Crawler for Silver Layer (discovers schema in cleaned data)
resource "aws_glue_crawler" "silver_crawler" {
  name          = "silver-crawler"
  role          = aws_iam_role.glue_role.arn
  database_name = aws_glue_catalog_database.silver_db.name

  s3_target {
    path = "s3://${aws_s3_bucket.silver.bucket}/"
  }

  schedule = "cron(30 0 * * ? *)" # Daily at 00:30 UTC
}

# Crawler for Gold Layer (discovers schema in analytics-ready data)
resource "aws_glue_crawler" "gold_crawler" {
  name          = "gold-crawler"
  role          = aws_iam_role.glue_role.arn
  database_name = aws_glue_catalog_database.gold_db.name

  s3_target {
    path = "s3://${aws_s3_bucket.gold.bucket}/"
  }

  schedule = "cron(0 1 * * ? *)" # Daily at 01:00 UTC
}

# -------------------------------
# Glue Jobs for ETL Between Layers
# -------------------------------

# Job: Bronze to Silver (cleans/transforms raw data)
resource "aws_glue_job" "bronze_to_silver" {
  name     = "bronze-to-silver-job"
  role_arn = aws_iam_role.glue_role.arn

  command {
    name            = "glueetl"
    script_location = "s3://${aws_s3_bucket.bronze.bucket}/scripts/bronze_to_silver.py"
    python_version  = "3"
  }

  default_arguments = {
    "--TempDir"      = "s3://${aws_s3_bucket.bronze.bucket}/temp/"
    "--job-language" = "python"
    "--source_db"    = aws_glue_catalog_database.bronze_db.name
    "--target_db"    = aws_glue_catalog_database.silver_db.name
  }

  number_of_workers   = 2
  worker_type         = "Standard"
  description         = "ETL job to transform data from bronze to silver stage"
}

# Job: Silver to Gold (aggregates/enriches data for analytics)
resource "aws_glue_job" "silver_to_gold" {
  name     = "silver-to-gold-job"
  role_arn = aws_iam_role.glue_role.arn

  command {
    name            = "glueetl"
    script_location = "s3://${aws_s3_bucket.silver.bucket}/scripts/silver_to_gold.py"
    python_version  = "3"
  }

  default_arguments = {
    "--TempDir"      = "s3://${aws_s3_bucket.silver.bucket}/temp/"
    "--job-language" = "python"
    "--source_db"    = aws_glue_catalog_database.silver_db.name
    "--target_db"    = aws_glue_catalog_database.gold_db.name
  }

  number_of_workers   = 2
  worker_type         = "Standard"
  description         = "ETL job to transform data from silver to gold stage"
}

# -------------------------------
# Notes:
# - Each Glue database represents a medallion layer (bronze, silver, gold).
# - Crawlers update the Glue Data Catalog with schema info for each layer.
# - Glue jobs automate ETL from bronze → silver and silver → gold.
# - Adjust script locations, schedules, and resources as needed for your pipeline.
# - The Glue role must have permissions to access all referenced S3 buckets and Glue
