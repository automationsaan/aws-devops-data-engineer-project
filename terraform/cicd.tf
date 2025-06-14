# cicd.tf - Defines AWS CI/CD resources for automating infrastructure and data pipeline deployments
# This file sets up an AWS CodePipeline for automating deployments and demonstrates how to use all three medallion layers (bronze, silver, gold) as artifact stores or deployment targets.

# ---------------------------------------------------------------------------
# Example: Create a CodeCommit repository for the pipeline source (if not already present)
# ---------------------------------------------------------------------------
resource "aws_codecommit_repository" "main" {
  repository_name = "data-pipeline-repo"
  description     = "Repository for data pipeline source code"
}

# ---------------------------------------------------------------------------
# Create the CodePipeline with three stages: Source, Transform, and Deploy
# Demonstrates using bronze, silver, and gold S3 buckets as artifact stores or deployment targets.
# ---------------------------------------------------------------------------
resource "aws_codepipeline" "main" {
  name     = "data-pipeline-cicd"
  role_arn = aws_iam_role.codepipeline.arn

  # Artifact store for pipeline artifacts (using bronze bucket for demonstration)
  artifact_store {
    location = aws_s3_bucket.bronze.bucket
    type     = "S3"
  }

  # Source stage: pulls code from CodeCommit and stores artifact in bronze bucket
  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_output"]
      configuration = {
        RepositoryName = aws_codecommit_repository.main.repository_name
        BranchName     = "main"
      }
    }
  }

  # Transform stage: (example) simulates a build or ETL process, stores output in silver bucket
  # In a real pipeline, this could be a CodeBuild or Glue job writing to the silver bucket.
  stage {
    name = "Transform"
    action {
      name             = "Transform"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["silver_output"]
      version          = "1"
      configuration = {
        ProjectName = "data-pipeline-transform-project"
        # The CodeBuild project should be configured to write outputs to the silver bucket.
      }
    }
  }

  # Deploy stage: (example) deploys analytics-ready data to the gold bucket
  # In a real pipeline, this could be another CodeBuild, Lambda, or custom action.
  stage {
    name = "Deploy"
    action {
      name             = "Deploy"
      category         = "Deploy"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["silver_output"]
      output_artifacts = ["gold_output"]
      version          = "1"
      configuration = {
        ProjectName = "data-pipeline-gold-project"
        # The CodeBuild project should be configured to write outputs to the gold bucket.
      }
    }
  }
}

# ---------------------------------------------------------------------------
# Notes:
# - This pipeline demonstrates a medallion architecture: Source (bronze) → Transform (silver) → Deploy (gold).
# - Each stage can be mapped to a CodeBuild project or other AWS service that writes to the respective S3 bucket.
# - You must define the referenced CodeBuild projects (data-pipeline-transform-project, data-pipeline-gold-project) elsewhere in your Terraform code.
# - Adjust the pipeline stages and actions to match your actual data pipeline and deployment process.
# - The artifact store S3 bucket must exist and be accessible by the pipeline role.
# - The CodeCommit repository is created here for demonstration; use your actual repository if it already exists.