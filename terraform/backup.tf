# backup.tf - Provisions AWS Backup resources for centralized backup management

# Create a Backup Vault to store backup copies of AWS resources
# - A backup vault is a container that stores and organizes backups created by AWS Backup.
# - Use this vault to manage, retain, and restore backups for services like RDS, EFS, DynamoDB, and more.
resource "aws_backup_vault" "main" {
  name = "pipeline-backup-vault" # Unique name for the backup vault
}

# Notes:
# - You can define backup plans and assignments to automate backups for supported AWS resources.
# - Centralized backup management helps with disaster recovery and compliance requirements.