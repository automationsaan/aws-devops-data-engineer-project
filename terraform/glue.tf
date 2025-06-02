# AWS Glue resources for ETL (Extract, Transform, Load) in the data pipeline.
# This file creates a Glue database, a sample Glue crawler, and a sample Glue job.
# These resources automate schema discovery and data transformation between S3 buckets.

# -------------------------------
# Glue Database
# -------------------------------
resource "aws_glue_catalog_database" "bronze_db" {
  name        = "bronze_db"
  description = "Glue database for raw/bronze stage data"
}

resource "aws_glue_catalog_database" "silver_db" {
  name        = "silver_db"
  description = "Glue database for cleaned/silver stage data"
}

# -------------------------------
# Glue Crawler
# -------------------------------
resource "aws_glue_crawler" "bronze_crawler" {
  name          = "bronze-crawler"
  role          = aws_iam_role.glue_role.arn
  database_name = aws_glue_catalog_database.bronze_db.name

  s3_target {
    path = "s3://data-pipeline-bronze-bucket/"
  }

  # The crawler will run on demand or can be scheduled
  schedule = "cron(0 0 * * ? *)" # Daily at midnight UTC

  # Classifiers can be added for custom file formats
  # classifiers = []
}

# -------------------------------
# Glue Job
# -------------------------------
resource "aws_glue_job" "bronze_to_silver" {
  name     = "bronze-to-silver-job"
  role_arn = aws_iam_role.glue_role.arn

  command {
    name            = "glueetl"
    script_location = "s3://data-pipeline-bronze-bucket/scripts/bronze_to_silver.py"
    python_version  = "3"
  }

  default_arguments = {
    "--TempDir"    = "s3://data-pipeline-bronze-bucket/temp/"
    "--job-language" = "python"
    "--source_db"  = aws_glue_catalog_database.bronze_db.name
    "--target_db"  = aws_glue_catalog_database.silver_db.name
  }

  number_of_workers   = 2
  worker_type         = "Standard"
  description         = "ETL job to transform data from bronze to silver stage"
}

# -------------------------------
# Notes:
# - The Glue role must have permissions to access S3 and Glue resources.
# - The crawler discovers schema in the bronze bucket and updates the Glue Data Catalog.
# - The Glue job transforms data from bronze to silver, using a script stored in S3.
# - Adjust schedule, script location, and resources as needed for your pipeline.
