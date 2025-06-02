# storage.tf - Provisions additional storage resources for the data pipeline

# Create an Amazon EFS (Elastic File System) for shared, scalable file storage
# - EFS provides a managed, elastic NFS file system that can be mounted by multiple EC2 instances or containers.
# - Use EFS for workloads that require shared access to files, such as big data processing, analytics, or ML pipelines.
resource "aws_efs_file_system" "main" {
  creation_token = "efs-for-pipeline" # Unique creation token to ensure idempotency
}

# Notes:
# - You can create mount targets in your VPC subnets to allow EC2 or ECS/EKS tasks to access this file system.
# - EFS is ideal for scenarios where you need persistent, shared storage across compute resources.