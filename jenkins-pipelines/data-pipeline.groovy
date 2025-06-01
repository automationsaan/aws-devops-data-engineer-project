// Jenkins Pipeline for Data Engineering Workflow
// This pipeline automates the end-to-end data pipeline: ingestion, transformation, and loading.
// It leverages AWS CLI, Glue, DMS, and Lambda to orchestrate data movement and processing.
// Each stage is modular, making it easy to troubleshoot and extend.
// Detailed comments are provided to explain the purpose and logic of each section.

pipeline {
    agent any // Run on any available Jenkins agent

    environment {
        // Set AWS region and key resource names as environment variables for reuse
        AWS_DEFAULT_REGION = 'us-east-1'
        BRONZE_BUCKET = 'data-pipeline-bronze-bucket'
        SILVER_BUCKET = 'data-pipeline-silver-bucket'
        GLUE_JOB_NAME = 'bronze-to-silver-job'
        DMS_TASK_ID = 'your-dms-task-id' // Replace with your actual DMS task ID
        LAMBDA_FUNCTION = 'your-lambda-function-name' // Replace with your Lambda function name
    }

    stages {
        stage('Ingest Data to S3 (Bronze)') {
            steps {
                echo 'Uploading raw data to S3 Bronze bucket...'
                // This step simulates data ingestion by uploading a sample file to the Bronze S3 bucket.
                // Replace this with your actual ingestion logic (e.g., pulling from an API, database, etc.).
                sh 'aws s3 cp data/raw/input.csv s3://${BRONZE_BUCKET}/input/input.csv'
            }
        }

        stage('Run Glue Crawler') {
            steps {
                echo 'Starting Glue Crawler to update schema...'
                // This step triggers the Glue Crawler to scan the Bronze bucket and update the Glue Data Catalog.
                // Keeping the schema up-to-date is critical for downstream ETL jobs.
                sh '''
                    aws glue start-crawler --name bronze-crawler
                    # Optionally, poll the crawler state to wait for completion or check status
                    aws glue get-crawler --name bronze-crawler --query "Crawler.State" --output text
                '''
            }
        }

        stage('Transform Data with Glue Job') {
            steps {
                echo 'Running Glue ETL job to process data from Bronze to Silver...'
                // This step starts the Glue ETL job, which reads from the Bronze bucket,
                // transforms the data, and writes the results to the Silver bucket.
                // Monitoring this job helps catch transformation errors early.
                sh '''
                    aws glue start-job-run --job-name ${GLUE_JOB_NAME}
                '''
            }
        }

        stage('Replicate Data with DMS') {
            steps {
                echo 'Starting DMS task to replicate/transmit data...'
                // This step starts an AWS DMS replication task, which moves or syncs data
                // (e.g., from S3/Silver to a database or data warehouse).
                // Useful for near-real-time data movement or migrations.
                sh '''
                    aws dms start-replication-task --replication-task-arn ${DMS_TASK_ID} --start-replication-task-type reload-target
                '''
            }
        }

        stage('Trigger Lambda for Post-Processing') {
            steps {
                echo 'Invoking Lambda function for post-processing or notifications...'
                // This step triggers a Lambda function, which can be used for post-processing,
                // notifications, or integration with other systems (e.g., Slack, SNS, etc.).
                sh '''
                    aws lambda invoke --function-name ${LAMBDA_FUNCTION} --payload '{}' lambda_output.json
                '''
            }
        }
    }

    post {
        always {
            echo 'Pipeline execution completed.'
            // Archive Lambda output for auditing or debugging purposes.
            archiveArtifacts artifacts: 'lambda_output.json', onlyIfSuccessful: true
        }
        failure {
            echo 'Pipeline failed. Please check the logs for details.'
            // You can add notifications here (e.g., email, Slack) for failed runs.
        }
    }
}

// Notes:
// - Replace placeholder values (DMS_TASK_ID, LAMBDA_FUNCTION) with your actual resource names/ARNs.
// - Each stage is independent, making it easy to rerun failed steps or extend the pipeline.
// - Add error handling, notifications, or additional stages as needed for your workflow.
// - This pipeline assumes AWS CLI is configured on the Jenkins agent and has the necessary IAM permissions.