# orchestration.tf - Defines orchestration resources for scheduling and managing data pipeline workflows

# Create an AWS Step Functions State Machine
# Step Functions orchestrate complex workflows by coordinating multiple AWS services and Lambda functions.
# - The state machine definition (in JSON) describes the workflow logic and steps.
# - The IAM role (step_functions) must have permissions to invoke all resources used in the workflow.
resource "aws_sfn_state_machine" "main" {
  name       = "pipeline-orchestration"                  # Unique name for the state machine
  role_arn   = aws_iam_role.step_functions.arn           # IAM role for Step Functions execution
  definition = file("state_machine_definition.json")     # Workflow definition (JSON file)
}

# Create an Amazon MWAA (Managed Workflows for Apache Airflow) Environment
# MWAA provides a fully managed Apache Airflow service for authoring, scheduling, and monitoring workflows.
# - DAGs (Directed Acyclic Graphs) are stored in the specified S3 path.
# - The execution role (mwaa_execution) must have permissions for all AWS resources used in Airflow tasks.
# - The source S3 bucket stores DAGs, plugins, and requirements for the Airflow environment.
resource "aws_mwaa_environment" "main" {
  name                = "airflow-env"                    # Unique name for the MWAA environment
  dag_s3_path         = "dags/"                          # S3 path for Airflow DAGs
  execution_role_arn  = aws_iam_role.mwaa_execution.arn  # IAM role for Airflow execution
  source_bucket_arn   = aws_s3_bucket.bronze.arn         # S3 bucket containing DAGs and other Airflow assets
}

# Notes:
# - Use Step Functions for serverless, event-driven orchestration of AWS services.
# - Use MWAA for complex, Python-based workflow scheduling and integration with the broader AWS ecosystem.
# - Ensure IAM roles have the necessary permissions for all orchestrated resources.