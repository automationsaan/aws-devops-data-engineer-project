#!/bin/bash
# scripts/setup-redshift.sh
# This script automates the setup of Amazon Redshift tables and optionally loads data.
# It uses the psql CLI to connect to Redshift and execute SQL scripts.
# Requires: psql (PostgreSQL client), AWS CLI, and Redshift credentials.

set -e

# --- Configuration ---
# Read Redshift endpoint, database, username, and password from environment variables or a config file.
# These can be set in your CI/CD pipeline or exported before running the script.

REDSHIFT_ENDPOINT="${REDSHIFT_ENDPOINT:-$(jq -r '.redshift_endpoint.value' terraform-outputs.json)}"
REDSHIFT_DB="${REDSHIFT_DB:-dev}"           # Change to your Redshift database name
REDSHIFT_USER="${REDSHIFT_USER:-admin}"     # Change to your Redshift username
REDSHIFT_PASSWORD="${REDSHIFT_PASSWORD:-YourPassword123}" # Change or export as a secret

# --- SQL Setup ---
# Path to your SQL file(s) for creating tables and loading data
SQL_FILE="scripts/redshift_setup.sql"

# --- Connect and Execute ---
export PGPASSWORD="$REDSHIFT_PASSWORD"

echo "Connecting to Redshift at $REDSHIFT_ENDPOINT and running setup SQL..."

psql -h "$REDSHIFT_ENDPOINT" -U "$REDSHIFT_USER" -d "$REDSHIFT_DB" -f "$SQL_FILE"

echo "Redshift setup complete."

# --- Notes ---
# - This script assumes you have a SQL file (e.g., redshift_setup.sql) with CREATE TABLE and/or COPY commands.
# - You can generate or update this SQL file as part of your ETL workflow.
# - For security, use environment variables or a secrets manager to provide credentials in production.
# - Ensure your IP or CI/CD runner is allowed by the Redshift security group.