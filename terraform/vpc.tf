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

# Notes:
# - This code creates a VPC and two public subnets for use by EC2, RDS, Lambda, and other AWS services.
# - The subnet CIDR blocks should be defined in variables.tf as 'public_subnet_cidrs'.
# - Public subnets are required for resources that need direct internet access.
