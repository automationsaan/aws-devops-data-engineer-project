# redshift.tf - Provisions an AWS Redshift cluster and supporting resources for the data pipeline

# Create a Redshift subnet group using all public subnets
# This subnet group tells Redshift which subnets it can use for its nodes.
resource "aws_redshift_subnet_group" "redshift" {
  name       = "redshift-subnet-group"
  subnet_ids = aws_subnet.public[*].id  # Reference all public subnets created in your VPC
}

# Create the Redshift cluster
resource "aws_redshift_cluster" "main" {
  cluster_identifier        = "data-pipeline-cluster"    # Unique identifier for the cluster
  node_type                 = "dc2.large"                # Node type (choose based on workload and cost)
  master_username           = var.db_username            # Master username (from variables or tfvars)
  master_password           = var.db_password            # Master password (from variables or tfvars, sensitive)
  cluster_type              = "single-node"              # Single-node for dev/test; use multi-node for prod
  publicly_accessible       = true                       # Allows access from outside the VPC (restrict in prod)
  skip_final_snapshot       = true                       # Skips snapshot on deletion (useful for dev/test)

  vpc_security_group_ids    = [aws_security_group.redshift.id] # Attach the Redshift security group for network access
  cluster_subnet_group_name = aws_redshift_subnet_group.redshift.name # Use the subnet group defined above

  tags = {
    Environment = "Dev"
    Name        = "data-pipeline-redshift"
  }
}

# Security group for Redshift cluster
# Controls inbound and outbound network access to the Redshift cluster.
resource "aws_security_group" "redshift" {
  name        = "redshift-sg"
  description = "Security group for Redshift cluster"
  vpc_id      = aws_vpc.main.id

  # Allow inbound access to Redshift port (5439) from anywhere (0.0.0.0/0)
  # WARNING: This is open to the world. Restrict to trusted IPs in production!
  ingress {
    from_port   = 5439
    to_port     = 5439
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
