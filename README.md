# AWS DevOps Data Engineer Project

## Project Overview

This project demonstrates a modern, end-to-end data engineering pipeline on AWS, fully automated with DevOps best practices. It covers the ingestion, transformation, and loading of data using AWS services, with infrastructure managed as code and CI/CD pipelines for both infrastructure and data workflows. The project leverages Python data and automation libraries (see `requirements.txt`) for ETL, orchestration, and monitoring tasks.

**Key Features and Enhancements:**
- **Full Medallion Architecture:** Implements bronze (raw), silver (curated), and gold (analytics-ready) layers using S3, Glue, Athena, and Redshift for scalable, modular data lake and warehouse design.
- **Security:** AWS Secrets Manager is used to securely store and manage sensitive credentials (such as database usernames and passwords), removing the need to expose secrets in plaintext files.
- **Streaming and Real-Time Ingestion:** Amazon MSK (Kafka), Kinesis Data Streams, and Kinesis Data Firehose for streaming and real-time data ingestion.
- **Schema Management:** AWS Glue Schema Registry for managing streaming data schemas.
- **Analytics and BI:** Amazon Redshift (data warehouse for analytics and BI), Amazon Athena (ad-hoc querying), and Amazon QuickSight (dashboarding).
- **Orchestration:** Amazon EventBridge, AWS Step Functions, and Amazon MWAA (Managed Airflow) for workflow orchestration and scheduling.
- **Machine Learning:** Amazon SageMaker for advanced analytics and ML.
- **Data Governance:** AWS Lake Formation for secure data lake management.
- **Monitoring and Auditing:** Amazon CloudWatch and AWS CloudTrail for monitoring and auditing across all medallion layers.
- **CI/CD Automation:** AWS CodePipeline, CodeBuild, CodeCommit, and CodeDeploy for infrastructure and data pipeline automation.
- **Database Migration:** AWS DMS (Database Migration Service) for batch and continuous data migration.
- **Automation Scripts:** (`init-dms.sh`, `setup-redshift.sh`, `trigger-lambda.sh`) for hands-off pipeline execution.

The project is designed for learning, prototyping, and as a template for production-grade data platforms.

---

## Architecture / AWS Services Used

Below is the architecture diagram for the project.

![Project Architecture](https://github.com/automationsaan/aws-devops-data-engineer-project/blob/main/project-pics/archtecture-2.png)

![AWS Services Used](https://github.com/automationsaan/aws-devops-data-engineer-project/blob/a058336db595e58a4d47592563c12407dfc0c1c9/project-pics/aws-services.png)

![AWS Services Used](https://github.com/automationsaan/aws-devops-data-engineer-project/blob/a058336db595e58a4d47592563c12407dfc0c1c9/project-pics/aws-services-2.png)

---

## Tools, Services, and Technologies Used

- **Medallion Architecture Layers**
  - **Bronze:** Raw/ingested data (S3, Glue, Athena, Redshift)
  - **Silver:** Cleaned/curated data (S3, Glue, Athena, Redshift)
  - **Gold:** Analytics-ready/business-level data (S3, Glue, Athena, Redshift, QuickSight)

- **Streaming and Batch Ingestion**
  - AWS DMS (Database Migration Service)
  - AWS Schema Conversion Tool (manual/script integration, automated via `run_sct.sh`)
  - Apache Kafka / Amazon MSK (Managed Streaming for Apache Kafka)
  - MSK Connect
  - Kinesis Data Streams
  - Kinesis Data Firehose
  - AWS Glue Schema Registry

- **Storage and Databases**
  - Amazon S3 (Bronze, Silver, Gold buckets)
  - Amazon Redshift (Data warehouse for analytics and BI)
  - Amazon EBS, Amazon EFS
  - AWS Backup
  - Amazon RDS, Amazon Aurora
  - Amazon DynamoDB, Amazon Neptune, Amazon DocumentDB, Amazon Timestream
  - AWS Lake Formation

- **Transforming and Processing**
  - AWS Glue (ETL, Schema Registry, Crawlers, Jobs for bronze, silver, gold)
  - AWS Lambda
  - Amazon EC2, ECR, ECS, EKS, EMR, AWS Batch
  - Managed Service for Apache Flink

- **Analyse and Query**
  - Amazon Redshift (Data warehouse for analytics and BI)
  - Amazon Athena (Ad-hoc querying for all medallion layers)
  - Amazon OpenSearch Service (Search analytics)

- **Schedule and Orchestrate**
  - Amazon EventBridge
  - AWS Step Functions
  - Amazon MWAA (Managed Workflows for Apache Airflow)
  - AWS Glue Workflows
  - Amazon SNS, Amazon SQS, Amazon AppFlow

- **Consume and Visualise**
  - Amazon QuickSight (Business intelligence and dashboarding on gold layer and Redshift)
  - Amazon SageMaker (Machine Learning)

- **Operationalise, Maintain, and Monitor**
  - Amazon CloudWatch (Monitoring)
  - AWS CloudTrail (Auditing for bronze, silver, gold)
  - Prometheus, Grafana (Custom metrics and dashboards)

- **Authentication, Authorization, Encryption, Governance**
  - AWS IAM (Access control)
  - AWS KMS (Encryption)
  - AWS Secrets Manager (Credential management)

- **ETL Pipeline Concepts**
  - Slowly Changing Dimensions (SCD I, SCD II) implemented in Glue scripts

- **CI/CD Tools**
  - Terraform (Infrastructure as Code)
  - Jenkins (CI/CD pipelines)
  - AWS CodeCommit, CodeBuild, CodeDeploy, CodePipeline
  - AWS CloudFormation, AWS SAM
  - Ansible (Configuration management)
  - Docker, Kubernetes

- **Python Data & Automation Libraries**
  - boto3, awscli (AWS automation and scripting)
  - pandas, pyarrow (Data processing and Parquet support)
  - requests (API calls and automation)
  - sqlalchemy, psycopg2-binary (Database connectivity)
  - jupyter (Interactive development and testing)
  - pytest (Unit testing)
  - prometheus_client (Custom metrics for monitoring)
  - pyyaml (YAML config handling)

- **Other**
  - Bash scripts for automation (`init-dms.sh`, `setup-redshift.sh`, `trigger-lambda.sh`)
  - Prometheus exporters for AWS, Jenkins, etc.

---

## Project Structure

```
aws-devops-data-engineer-project/
├── ansible/
│   └── playbooks/
│       ├── deploy_jenkins.yml
│       ├── deploy_prometheus.yml
│       └── deploy_grafana.yml
├── docker/
│   ├── jenkins/
│   │   └── Dockerfile
│   ├── prometheus/
│   │   └── prometheus.yml
│   └── grafana/
│       └── dashboards/
│           └── pipeline_dashboard.json
├── kubernetes/
│   ├── jenkins/
│   │   └── jenkins-deployment.yaml
│   ├── prometheus/
│   │   └── prometheus-deployment.yaml
│   └── grafana/
│       └── grafana-deployment.yaml
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── vpc.tf
│   ├── rds.tf
│   ├── s3.tf
│   ├── glue.tf
│   ├── redshift.tf
│   ├── iam.tf
│   ├── secrets.tf
│   ├── kafka.tf
│   ├── kinesis.tf
│   ├── athena.tf
│   ├── opensearch.tf
│   ├── lakeformation.tf
│   ├── orchestration.tf
│   ├── sagemaker.tf
│   ├── monitoring.tf
│   ├── cicd.tf
│   ├── backup.tf
│   ├── storage.tf
│   ├── quicksight.tf
│   ├── glue_schema.tf
│   ├── dms.tf
│   ├── dms-table-mappings.json
│   ├── dms-task-settings.json
│   ├── state_machine_definition.json
│   └── terraform.tfvars
├── jenkins-pipelines/
│   ├── infrastructure-pipeline.groovy
│   └── data-pipeline.groovy
├── monitoring/
│   ├── alerts/
│   │   └── prometheus-alert.rules
│   └── dashboards/
│       └── grafana-dashboard.json
├── scripts/
│   ├── run_sct.sh
│   ├── init-dms.sh
│   ├── setup-redshift.sh
│   └── trigger-lambda.sh
├── project-pics/
│   ├── archtecture-2.png
│   ├── aws-services.png
│   └── aws-services-2.png
├── .gitignore
├── README.md
└── requirements.txt
```

---

## Automation Scripts

- **run_sct.sh**: Automates schema conversion using AWS SCT CLI.
- **init-dms.sh**: Starts the DMS replication task using the ARN from Terraform outputs.
- **setup-redshift.sh**: Connects to Redshift and runs SQL scripts to create tables or load data.
- **trigger-lambda.sh**: Invokes a Lambda function for post-processing or notifications.

---

## Getting Started: Step-by-Step Setup Instructions

### 1. Prerequisites

- **AWS Account** with sufficient permissions (IAM, S3, DMS, Redshift, Glue, etc.)
- **AWS CLI** installed and configured (`aws configure`)
- **Terraform** installed (v1.3.0+)
- **jq** installed (for shell scripts)
- **psql** (PostgreSQL client) installed (for Redshift setup)
- **Python 3** and `pip` (for ETL scripts)
- **Git** installed
- **(Optional) Jenkins** or another CI/CD tool if you want to run pipelines

---

### 2. Clone the Repository

```sh
git clone https://github.com/automationsaan/aws-devops-data-engineer-project.git
cd aws-devops-data-engineer-project
```

---

### 3. Configure Variables Securely

- **DO NOT store sensitive information (like database usernames and passwords) in version control.**
- Use the provided `terraform/terraform.tfvars.example` file as a template:
  1. Copy it to `terraform/terraform.tfvars`:
     ```sh
     cp terraform/terraform.tfvars.example terraform/terraform.tfvars
     ```
  2. Edit `terraform/terraform.tfvars` and fill in your actual values for `db_username`, `db_password`, and any other required variables.
- **Important:**  
  Ensure `terraform/terraform.tfvars` is listed in your `.gitignore` file so it is never committed to your repository.  
  Example `.gitignore` entry:
  ```
  terraform/terraform.tfvars
  ```

---

### 4. Create Required JSON Files for DMS and Step Functions

In the `terraform/` directory, create:
- `dms-table-mappings.json` (table selection rules)
- `dms-task-settings.json` (optional, can be `{}`)
- `state_machine_definition.json` (required for Step Functions)

Example for `dms-table-mappings.json`:
```json
{
  "rules": [
    {
      "rule-type": "selection",
      "rule-id": "1",
      "rule-name": "1",
      "object-locator": {
        "schema-name": "%",
        "table-name": "%"
      },
      "rule-action": "include"
    }
  ]
}
```

Example for `dms-task-settings.json` (minimal):
```json
{}
```

Example for `state_machine_definition.json` (minimal):
```json
{
  "Comment": "Minimal Step Function definition",
  "StartAt": "DummyState",
  "States": {
    "DummyState": {
      "Type": "Pass",
      "End": true
    }
  }
}
```

---

### 5. Provision Infrastructure with Terraform

```sh
cd terraform
terraform init
terraform plan
terraform apply
terraform output -json > ../terraform-outputs.json
cd ..
```

---

### 6. Run Automation Scripts (Optional/Recommended)

- **Schema Conversion:**  
  If using SCT CLI, run:
  ```sh
  ./scripts/run_sct.sh
  ```

- **Start DMS Replication Task:**  
  ```sh
  ./scripts/init-dms.sh
  ```

- **Set Up Redshift Tables:**  
  ```sh
  ./scripts/setup-redshift.sh
  ```

- **Trigger Lambda Function:**  
  ```sh
  ./scripts/trigger-lambda.sh
  ```

---

### 7. (Optional) Run Jenkins Pipelines

- Configure Jenkins to use the `jenkins-pipelines/data-pipeline.groovy` and/or `infrastructure-pipeline.groovy` files.
- Make sure your Jenkins agent has AWS CLI, Terraform, Python, jq, and psql installed.

---

### 8. Monitor and Validate

- Use AWS Console to monitor resources (DMS, Redshift, Glue, Lambda, etc.).
- Check CloudWatch logs for troubleshooting.
- Use QuickSight for BI/dashboarding and Redshift analytics.

---

### 9. Tear Down Resources (When Done)

```sh
cd terraform
terraform destroy
```

---

### Tips

- **Never commit secrets or credentials to git.**
- Use AWS Secrets Manager for production credentials.
- Adjust security groups and IAM roles for your environment.
- Review costs in the AWS Console.

---

## Troubleshooting

- Check Jenkins logs for pipeline errors.
- Use `terraform destroy` to tear down resources when done.
- Review AWS CloudWatch for service-specific logs.
- Ensure all AWS resource names are unique per account/region.
- Validate all JSON files (no comments, valid syntax).

---

## License

MIT License

---

## Author

- Saan Saechao