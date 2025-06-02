# lakeformation.tf - Configures AWS Lake Formation for data lake governance and security

# Configure Lake Formation data lake settings
# - This resource sets up Lake Formation and assigns admin users who can manage permissions, catalogs, and data governance.
# - The 'admins' parameter specifies which IAM users have administrative control over the data lake.
resource "aws_lakeformation_data_lake_settings" "main" {
  admins = [aws_iam_user.admin.arn] # List of IAM users with Lake Formation admin privileges
}

# Notes:
# - Lake Formation helps manage access, security, and governance for your data lake on AWS.
# - Ensure the specified IAM user exists and has appropriate permissions.