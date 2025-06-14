# Defines VPC and two public subnets for EC2, RDS, Lambda, and other AWS services.

# Create the main VPC for your infrastructure.
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr                # The IP range for the VPC, defined in variables.tf
  enable_dns_support   = true                        # Enable DNS support in the VPC
  enable_dns_hostnames = true                        # Enable DNS hostnames for instances

  tags = {
    Name = "data-pipeline-vpc"
    Environment = "dev"
  }
}

# Create two public subnets in different Availability Zones for high availability.
resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.public_subnet_cidrs, count.index)  # Get each subnet CIDR from a variable list
  availability_zone       = element(["us-east-1a", "us-east-1b"], count.index)  # Spread subnets across AZs
  map_public_ip_on_launch = true  # Automatically assign public IPs to instances launched in this subnet

  tags = {
    Name = "public-subnet-${count.index + 1}"
    Environment = "dev"
  }
}

# ---------------------------------------------------------------------------
# Security Groups for DMS and MSK
# ---------------------------------------------------------------------------

# Default security group for general use (e.g., DMS replication instance)
# This security group allows all outbound traffic and can be customized for inbound rules as needed.
resource "aws_security_group" "default" {
  name        = "default-sg"
  description = "Default security group for DMS and general use"
  vpc_id      = aws_vpc.main.id

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Example: Allow inbound traffic on port 3306 (MySQL) from within the VPC
  # (Uncomment and adjust as needed)
  # ingress {
  #   from_port   = 3306
  #   to_port     = 3306
  #   protocol    = "tcp"
  #   cidr_blocks = [aws_vpc.main.cidr_block]
  # }

  tags = {
    Name = "default-sg"
    Environment = "dev"
  }
}

# Security group for MSK (Managed Streaming for Apache Kafka) cluster
# This security group allows all outbound traffic and can be customized for Kafka ports as needed.
resource "aws_security_group" "msk" {
  name        = "msk-sg"
  description = "Security group for MSK cluster"
  vpc_id      = aws_vpc.main.id

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Example: Allow inbound traffic on Kafka port 9092 from within the VPC
  # (Uncomment and adjust as needed)
  # ingress {
  #   from_port   = 9092
  #   to_port     = 9092
  #   protocol    = "tcp"
  #   cidr_blocks = [aws_vpc.main.cidr_block]
  # }

  tags = {
    Name = "msk-sg"
    Environment = "dev"
  }
}

# Notes:
# - This code creates a VPC and two public subnets for use by EC2, RDS, Lambda, and other AWS services.
# - The subnet CIDR blocks should be defined in variables.tf as 'public_subnet_cidrs'.
# - Public subnets are required for resources that need direct internet access.
# - These security groups are required for DMS and MSK resources referenced in other Terraform files.
# - Adjust ingress rules as needed for your application's security requirements.
# - Security groups control network access to AWS resources within your VPC.
