# terraform.tfvars - Provides values for Terraform input variables.
# This file is automatically loaded by Terraform to set variable values for your configuration.
# It is especially useful for variables that do not have defaults or for environment-specific overrides.

# public_subnet_cidrs:
# This variable defines a list of CIDR blocks for the public subnets in your VPC.
# Each CIDR block represents a separate public subnet that will be created in your AWS environment.
# These subnets are typically used for resources that need direct access to the internet (e.g., NAT gateways, public-facing EC2 instances).
# Adjust the CIDR blocks as needed to fit your network design and avoid overlap with other networks.

public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
