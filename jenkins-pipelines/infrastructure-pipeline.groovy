// Jenkins Pipeline for Infrastructure Provisioning with Terraform
// This pipeline automates the provisioning and teardown of AWS infrastructure using Terraform.
// It ensures infrastructure-as-code best practices, repeatability, and safe deployments.
// Detailed comments explain each stage and its purpose.

pipeline {
    agent any // Run on any available Jenkins agent

    environment {
        // Set AWS region and Terraform working directory as environment variables
        AWS_DEFAULT_REGION = 'us-east-1'
        TF_WORKING_DIR = 'terraform'
    }

    stages {
        stage('Checkout Source') {
            steps {
                echo 'Checking out source code from version control...'
                // Ensures the latest code and Terraform configurations are used.
                // This step pulls the most recent commit from your source repository.
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                echo 'Initializing Terraform...'
                // Downloads required Terraform providers and sets up the backend for state management.
                // This is a prerequisite for all subsequent Terraform commands.
                dir("${TF_WORKING_DIR}") {
                    sh 'terraform init -input=false'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                echo 'Validating Terraform configuration...'
                // Checks for syntax errors and best practices in Terraform code.
                // Fails early if there are issues, preventing bad deployments.
                dir("${TF_WORKING_DIR}") {
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                echo 'Planning infrastructure changes...'
                // Generates and displays an execution plan without making changes.
                // The plan shows what actions Terraform will take, allowing for review and approval.
                dir("${TF_WORKING_DIR}") {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                // Manual approval step to prevent accidental changes to infrastructure.
                // This is a best practice for production environments.
                input message: 'Approve infrastructure changes?', ok: 'Apply'
                echo 'Applying infrastructure changes...'
                // Applies the planned changes to AWS, provisioning or updating resources as defined.
                dir("${TF_WORKING_DIR}") {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }

        stage('Post-Provisioning Actions') {
            steps {
                echo 'Running post-provisioning steps (if any)...'
                // Placeholder for any scripts or commands needed after infrastructure is provisioned.
                // Examples: configuring monitoring, registering resources, or sending notifications.
            }
        }
    }

    post {
        always {
            echo 'Infrastructure pipeline execution completed.'
            // Archives Terraform state files for auditing, disaster recovery, and traceability.
            // This helps track infrastructure changes over time.
            archiveArtifacts artifacts: "${TF_WORKING_DIR}/terraform.tfstate*", allowEmptyArchive: true
        }
        failure {
            echo 'Infrastructure pipeline failed. Please check the logs for details.'
            // Add notifications here (e.g., email, Slack) for failed runs to alert the team.
        }
    }
}

// Notes:
// - This pipeline assumes Terraform and AWS CLI are installed and configured on the Jenkins agent.
// - Use Jenkins credentials binding or plugins for secure AWS access.
// - You can add a destroy stage for teardown if needed (with manual approval).
// - Modular stages and detailed logging make troubleshooting and auditing easier.