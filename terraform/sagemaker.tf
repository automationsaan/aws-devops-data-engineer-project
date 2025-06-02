# sagemaker.tf - Provisions a SageMaker notebook instance for machine learning and analytics

# Create a SageMaker Notebook Instance
# This resource provisions a managed Jupyter notebook environment for data exploration, model development, and analytics.
# - The notebook instance can access data in S3, Redshift, or other AWS services using the attached IAM role.
# - Use this for building, training, and deploying machine learning models as part of your data pipeline.
resource "aws_sagemaker_notebook_instance" "main" {
  name          = "data-pipeline-notebook"              # Unique name for the notebook instance
  instance_type = "ml.t2.medium"                        # Instance type (choose based on workload and cost)
  role_arn      = aws_iam_role.sagemaker_execution.arn  # IAM role granting permissions to access AWS resources
}

# Notes:
# - The IAM role (sagemaker_execution) should have permissions for S3, SageMaker, and any other required services.
# - You can install additional libraries and persist notebooks in S3 for collaboration and reproducibility.