# cicd.tf - Defines AWS CI/CD resources for automating infrastructure and data pipeline deployments

# Create a CodeCommit repository to store source code (infrastructure, ETL scripts, etc.)
# CodeCommit is a fully managed source control service that hosts secure Git-based repositories.
resource "aws_codecommit_repository" "main" {
  repository_name = "data-pipeline-repo" # Unique name for the repository
}

# Create a CodePipeline for CI/CD automation
# CodePipeline automates the build, test, and deploy phases of your release process every time there is a code change.
resource "aws_codepipeline" "main" {
  name     = "data-pipeline-cicd"                # Unique name for the pipeline
  role_arn = aws_iam_role.codepipeline.arn       # IAM role that CodePipeline assumes to execute actions

  artifact_store {
    location = aws_s3_bucket.bronze.bucket       # S3 bucket to store pipeline artifacts (e.g., build outputs)
    type     = "S3"
  }

  # Add stages (source, build, deploy, etc.) as needed for your pipeline.
  # Stages define the workflow for your CI/CD process.
}

# Notes:
# - CodeCommit provides version control for your codebase.
# - CodePipeline enables automated, repeatable deployments and integration with other AWS services.
# - Ensure the IAM role (codepipeline) has the necessary permissions for all pipeline actions.