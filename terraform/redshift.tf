# Deploys a single-node Reshift cluster for gold data
# Uses same username/password as RDS (or this can be different)
resource "aws_redshift_subnet_group" "redshift" {
  name       = "redshift-subnet-group"
  subnet_ids = aws_subnet.public[*].id
}

resource "aws_redshift_cluster" "main" {
  cluster_identifier = "data-pipeline-cluster"
  node_type          = "dc2.large"
  master_username    = var.db_username
  master_password    = var.db_password
  cluster_type       = "single-node"
  publicly_accessible = true
  skip_final_snapshot = true

  vpc_security_group_ids = [aws_security_group.redshift.id]
  cluster_subnet_group_name = aws_redshift_subnet_group.redshift.name

  tags = {
    Environment = "Dev"
    Name        = "data-pipeline-redshift"
  }
}
