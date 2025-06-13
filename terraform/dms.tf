# dms.tf - Provisions AWS Database Migration Service (DMS) resources for data migration workflows

# 1. DMS Replication Instance
# This is the compute resource that runs your DMS migration tasks.
resource "aws_dms_replication_instance" "main" {
  replication_instance_id        = "data-pipeline-dms-instance"
  replication_instance_class     = "dms.t3.medium"      # Choose instance size based on workload
  allocated_storage              = 50                   # Storage in GB
  publicly_accessible            = false                # Set to true if endpoints are public
  vpc_security_group_ids         = [aws_security_group.default.id] # Reference your security group
  apply_immediately              = true

  tags = {
    Name = "data-pipeline-dms-instance"
  }
}

# 2. DMS Source Endpoint
# Replace with your actual source DB engine and connection details.
resource "aws_dms_endpoint" "source" {
  endpoint_id               = "source-endpoint"
  endpoint_type             = "source"
  engine_name               = "mysql"                   # Change to your source DB engine (e.g., postgres, oracle, etc.)
  username                  = var.db_username           # Use variables for credentials
  password                  = var.db_password
  server_name               = aws_db_instance.mysql.address
  port                      = 3306                      # Change to your source DB port
  database_name             = "source_db"               # Change to your source DB name

  tags = {
    Name = "source-endpoint"
  }
}

# 3. DMS Target Endpoint
# Replace with your actual target DB engine and connection details.
resource "aws_dms_endpoint" "target" {
  endpoint_id               = "target-endpoint"
  endpoint_type             = "target"
  engine_name               = "postgres"                # Change to your target DB engine (e.g., redshift, mysql, etc.)
  username                  = var.db_username
  password                  = var.db_password
  server_name               = aws_redshift_cluster.main.endpoint
  port                      = 5439                      # Change to your target DB port
  database_name             = "target_db"               # Change to your target DB name

  tags = {
    Name = "target-endpoint"
  }
}

# 4. DMS Replication Task
# This defines the actual migration/replication job.
resource "aws_dms_replication_task" "main" {
  replication_task_id          = "data-pipeline-dms-task"
  migration_type               = "full-load"            # Options: full-load, cdc, full-load-and-cdc
  replication_instance_arn     = aws_dms_replication_instance.main.replication_instance_arn
  source_endpoint_arn          = aws_dms_endpoint.source.endpoint_arn
  target_endpoint_arn          = aws_dms_endpoint.target.endpoint_arn
  table_mappings               = file("${path.module}/dms-table-mappings.json") # JSON file describing table mappings
  replication_task_settings    = file("${path.module}/dms-task-settings.json")  # JSON file for task settings (optional)

  tags = {
    Name = "data-pipeline-dms-task"
  }
}

# Notes:
# - Update engine_name, ports, and database_name for your actual source and target databases.
# - Create the referenced JSON files (dms-table-mappings.json, dms-task-settings.json) in your terraform directory.
# - Ensure your security groups and networking allow connectivity between DMS and your databases.
# - Use Secrets Manager for credentials in production