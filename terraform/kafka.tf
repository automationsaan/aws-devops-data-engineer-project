# kafka.tf - Provisions an Amazon MSK (Managed Streaming for Apache Kafka) cluster for streaming data ingestion

# Create an MSK cluster for scalable, managed Apache Kafka streaming
# - MSK provides a fully managed Kafka service for ingesting, buffering, and processing real-time data streams.
# - Use this cluster to enable event-driven architectures, real-time analytics, and decoupled microservices.
resource "aws_msk_cluster" "main" {
  cluster_name           = "data-pipeline-msk"         # Unique name for the MSK cluster
  kafka_version          = "3.4.0"                     # Kafka version to deploy
  number_of_broker_nodes = 2                           # Number of broker nodes (increase for higher availability and throughput)

  broker_node_group_info {
    instance_type   = "kafka.m5.large"                 # EC2 instance type for each broker node
    client_subnets  = aws_subnet.public[*].id          # List of subnet IDs for broker nodes (ensure subnets exist)
    security_groups = [aws_security_group.msk.id]      # Security group(s) for network access control
  }
}

# Notes:
# - Adjust the number of broker nodes and instance type based on your workload and availability requirements.
# - Ensure the referenced subnets and security group are defined elsewhere in your Terraform configuration.
# - MSK enables reliable, scalable streaming for real-time data pipelines.