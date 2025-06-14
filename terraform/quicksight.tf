# This file provisions an AWS QuickSight admin user for analytics and dashboarding.
# QuickSight is AWS's BI (Business Intelligence) service for visualizing and analyzing data in your medallion architecture.

# ---------------------------------------------------------------------------
# Create an IAM user to be used as the QuickSight admin.
# This IAM user will be associated with the QuickSight admin role.
resource "aws_iam_user" "quicksight_admin" {
  name = "quicksight-admin"
}

# ---------------------------------------------------------------------------
# Get the current AWS account ID.
# This is needed to associate the QuickSight user with your AWS account.
data "aws_caller_identity" "current" {}

# ---------------------------------------------------------------------------
# Create a QuickSight user with ADMIN role.
# - user_name: The username for QuickSight.
# - email: The email address for notifications (replace with your own).
# - identity_type: "IAM" means this user is managed via IAM.
# - user_role: "ADMIN" gives full admin privileges in QuickSight.
# - aws_account_id: The AWS account where QuickSight is enabled.
# - iam_arn: The ARN of the IAM user to associate with this QuickSight user.
resource "aws_quicksight_user" "admin" {
  user_name      = "quicksight-admin"
  email          = "your-email@example.com" # Change to your email
  identity_type  = "IAM"
  user_role      = "ADMIN"
  aws_account_id = data.aws_caller_identity.current.account_id
  iam_arn        = aws_iam_user.quicksight_admin.arn
}

# ---------------------------------------------------------------------------
# Output the ARN of the QuickSight admin IAM user for reference.
output "quicksight_admin_user_arn" {
  description = "ARN of the QuickSight admin user"
  value       = aws_iam_user.quicksight_admin.arn
}

# ---------------------------------------------------------------------------
# Notes:
# - Replace the email address with your own to receive notifications from QuickSight.
# - This setup enables you to manage QuickSight users and permissions via Terraform.

# - The QuickSight admin can create dashboards and analyses on data in your bronze, silver, and gold layers.# - The QuickSight admin can create dashboards and analyses on data in your bronze, silver, and gold layers.