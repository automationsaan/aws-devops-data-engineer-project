# opensearch.tf - Provisions an Amazon OpenSearch Service domain for search and analytics

# Create an OpenSearch domain for indexing and querying data
# - OpenSearch is used for full-text search, log analytics, and real-time data exploration.
# - The domain can ingest data from S3, Kinesis, or other pipeline components for search and visualization.
resource "aws_opensearch_domain" "main" {
  domain_name     = "data-pipeline-search"   # Unique name for the OpenSearch domain
  engine_version  = "OpenSearch_2.11"        # Specify the OpenSearch engine version

  cluster_config {
    instance_type  = "t3.small.search"       # Instance type for data and master nodes (choose based on workload)
    instance_count = 1                       # Number of nodes in the cluster (increase for HA/scale)
  }
}

# Notes:
# - Adjust instance type and count for production workloads.
# - Configure access policies, encryption, and VPC integration as needed for security and compliance.