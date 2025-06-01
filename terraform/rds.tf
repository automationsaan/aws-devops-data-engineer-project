# Creates an RDS MySQL database, associates it with public subnets, and allows public access (should be restricted in production).

# This resource defines a DB subnet group, which tells AWS which subnets the RDS instance can use.
# Using public subnets here for demonstration; for production, use private subnets for better security.
resource "aws_db_subnet_group" "mysql" {
  name       = "mysql-subnet-group"
  subnet_ids = aws_subnet.public[*].id  # Reference all public subnets created in vpc.tf

  # No tags here, but you can add them if you want to track resources.
}

# This resource creates the actual RDS MySQL database instance.
resource "aws_db_instance" "mysql" {
  allocated_storage    = 20                       # The amount of storage (in GB) for your DB.
  engine               = "mysql"                  # Database engine type.
  engine_version       = "8.0"                    # MySQL version.
  instance_class       = "db.t3.micro"            # Instance size/type (smallest for demo).
  username             = var.db_username          # Master username (should be set in variables.tf or tfvars).
  password             = var.db_password          # Master password (should be set in variables.tf or tfvars).
  db_subnet_group_name = aws_db_subnet_group.mysql.name  # Attach to the subnet group above.
  vpc_security_group_ids = [aws_security_group.rds.id]   # Attach to the security group below.
  skip_final_snapshot  = true                     # Don't create a final snapshot on deletion (not for prod!).
  publicly_accessible  = true                     # Allow public access (for demo only; set to false for prod).

  tags = {
    Name        = "data-pipeline-rds"
    Environment = "dev"
  }
}

# This security group controls what can connect to the RDS instance.
resource "aws_security_group" "rds" {
  name        = "data-pipeline-rds-sg"
  description = "Allow database access"
  vpc_id      = aws_vpc.main.id

  # Ingress rule: allow incoming connections on the MySQL port (3306) from anywhere.
  # WARNING: This is for demonstration only. Restrict to trusted IPs or VPCs in production!
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow all IPs for demo; restrict in production!
  }

  # Egress rule: allow all outbound traffic (default for most use cases).
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "data-pipeline-rds-sg"
  }
}

# Notes:
# - This creates a MySQL RDS instance in the VPC and subnets defined in vpc.tf.
# - Security group allows public access for demonstration; restrict for production.
# - Use AWS Secrets Manager or SSM Parameter Store for sensitive credentials in production.
# - For PostgreSQL, change engine and port numbers accordingly.
