# orchestration.tf - Defines orchestration resources for scheduling and managing data pipeline workflows

# ---------------------------------------------------------------------------
# 1. AWS Step Functions State Machine
# ---------------------------------------------------------------------------
# Step Functions orchestrate complex workflows by coordinating multiple AWS services and Lambda functions.
# - The state machine definition (in JSON) describes the workflow logic and steps.
# - The IAM role (step_functions) must have permissions to invoke all resources used in the workflow.
# - The definition file must exist in your terraform directory.

resource "aws_sfn_state_machine" "main" {
  name       = "pipeline-orchestration"                  # Unique name for the state machine
  role_arn   = aws_iam_role.step_functions.arn           # IAM role for Step Functions execution
  definition = file("${path.module}/state_machine_definition.json")     # Workflow definition (JSON file)
}

# ---------------------------------------------------------------------------
# 2. Amazon MWAA (Managed Workflows for Apache Airflow) Environment
# ---------------------------------------------------------------------------
# MWAA provides a fully managed Apache Airflow service for authoring, scheduling, and monitoring workflows.
# - DAGs (Directed Acyclic Graphs) are stored in the specified S3 path.
# - The execution role (mwaa_execution) must have permissions for all AWS resources used in Airflow tasks.
# - The source S3 bucket stores DAGs, plugins, and requirements for the Airflow environment.
# - At least one network_configuration block is required.

resource "aws_mwaa_environment" "main" {
  name                = "airflow-env"                    # Unique name for the MWAA environment
  dag_s3_path         = "dags/"                          # S3 path for Airflow DAGs
  execution_role_arn  = aws_iam_role.mwaa_execution.arn  # IAM role for Airflow execution
  source_bucket_arn   = aws_s3_bucket.bronze.arn         # S3 bucket containing DAGs and other Airflow assets

  # Required: Define network configuration for MWAA environment
  network_configuration {
    security_group_ids = [aws_security_group.default.id]              # Security group for MWAA
    subnet_ids         = [aws_subnet.public[0].id, aws_subnet.public[1].id]  # At least one subnet required
  }
}

# ---------------------------------------------------------------------------
# Notes:
# - Ensure the file 'state_machine_definition.json' exists in your terraform directory.
#   For a minimal valid file, you can use:
#   {
#     "Comment": "Minimal Step Function definition",
#     "StartAt": "DummyState",
#     "States": {
#       "DummyState": {
#         "Type": "Pass",
#         "End": true
#       }
#     }
#   }
# - The MWAA environment requires at least one network_configuration block.
# - Adjust security group and subnet references as needed for your VPC setup.
# - Ensure IAM roles have the necessary permissions for all orchestrated resources.