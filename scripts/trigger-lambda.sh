#!/bin/bash
# scripts/trigger-lambda.sh
# This script triggers an AWS Lambda function using the AWS CLI.
# It is useful for automating post-processing, notifications, or other serverless tasks as part of your data pipeline.

set -e

# --- Configuration ---
# Read the Lambda function name or ARN from environment variables or a config file.
# You can export LAMBDA_FUNCTION_NAME or read it from terraform-outputs.json for automation.

LAMBDA_FUNCTION_NAME="${LAMBDA_FUNCTION_NAME:-my-data-pipeline-lambda}" # Replace with your Lambda function name or ARN

# Optional: Payload to send to the Lambda function (as JSON)
# You can customize this payload or read it from a file if needed.
PAYLOAD='{"key": "value"}'

# --- Invoke Lambda ---
echo "Invoking Lambda function: $LAMBDA_FUNCTION_NAME"
aws lambda invoke \
    --function-name "$LAMBDA_FUNCTION_NAME" \
    --payload "$PAYLOAD" \
    --invocation-type RequestResponse \
    output.json

echo "Lambda invocation complete. Response written to output.json."

# --- Notes ---
# - This script uses AWS CLI to invoke the Lambda function synchronously and writes the response to output.json.
# - Customize the PAYLOAD variable as needed for your Lambda use case.
# - For automation, you can read the function name from terraform outputs or environment variables.
# - Ensure your AWS CLI is configured with credentials and region, and has permission to invoke