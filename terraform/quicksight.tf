resource "aws_quicksight_user" "admin" {
  user_name     = "quicksight-admin"
  email         = "your-email@example.com" # Change to your email
  identity_type = "IAM"
  user_role     = "ADMIN"
  aws_account_id = data.aws_caller_identity.current.account_id
  iam_arn       = aws_iam_user.quicksight_admin.arn
}

resource "aws_iam_user" "quicksight_admin" {
  name = "quicksight-admin"
}

data "aws_caller_identity" "current" {}

output "quicksight_admin_user_arn" {
  description = "ARN of the QuickSight admin user"
  value       = aws_iam_user.quicksight_admin.arn
}