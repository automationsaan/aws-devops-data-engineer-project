#!/bin/bash
# scripts/init-dms.sh
# This script starts an AWS DMS replication task using the ARN from Terraform outputs.

set -e

# Read the DMS task ARN from the Terraform outputs JSON file
DMS_TASK_ARN=$(jq -r '.dms_task_arn.value' terraform-outputs.json)

if [[ -z "$DMS_TASK_ARN" || "$DMS_TASK_ARN" == "null" ]]; then
  echo "Error: DMS_TASK_ARN not found in terraform-outputs.json"
  exit 1
fi

echo "Starting DMS replication task: $DMS_TASK_ARN"
aws dms start-replication-task \
    --replication-task-arn "$DMS_TASK_ARN" \
    --start-replication-task-type start-replication

echo "Waiting for DMS task to reach 'running' state..."
while true; do
    STATUS=$(aws dms describe-replication-tasks --filters "Name=replication-task-arn,Values=$DMS_TASK_ARN" \
        --query "ReplicationTasks[0].Status" --output text)
    echo "Current status: $STATUS"
    if [[ "$STATUS" == "running" ]]; then
        echo "DMS replication task is running."
        break
    elif [[ "$STATUS" == "failed" || "$STATUS" == "stopped" ]]; then
        echo "DMS replication task failed or stopped."
        exit 1
    fi
    sleep 10
done

echo "DMS task started successfully."