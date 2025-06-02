# AWS DevOps Data Engineer Project

## Project Overview

This project demonstrates a modern, end-to-end data engineering pipeline on AWS, fully automated with DevOps best practices. It covers the ingestion, transformation, and loading of data using AWS services, with infrastructure managed as code and CI/CD pipelines for both infrastructure and data workflows. The project leverages Python data and automation libraries (see `requirements.txt`) for ETL, orchestration, and monitoring tasks.

**Security, streaming, analytics, and orchestration enhancements:**
- **AWS Secrets Manager** is used to securely store and manage sensitive credentials (such as database usernames and passwords), removing the need to expose secrets in plaintext files.
- **Amazon QuickSight** is integrated for business intelligence and dashboarding, enabling visualization and analytics on your data lake and warehouse.
- **Amazon MSK (Managed Streaming for Apache Kafka)**, **Kinesis Data Streams**, and **Kinesis Data Firehose** are included for streaming and real-time ingestion.
- **AWS Glue Schema Registry** is used for managing streaming data schemas.
- **Amazon Athena** and **Amazon OpenSearch Service** are available for ad-hoc querying and search analytics.
- **Amazon EventBridge**, **AWS Step Functions**, and **Amazon MWAA (Managed Airflow)** are available for orchestration and scheduling.
- **Amazon SageMaker** is included for machine learning and advanced analytics.
- **AWS Lake Formation** is used for data governance and secure data lake management.
- **Amazon CloudWatch** and **AWS CloudTrail** are integrated for monitoring and auditing.
- **AWS CodePipeline**, **CodeBuild**, **CodeCommit**, and **CodeDeploy** are available for CI/CD automation.

The project is designed for learning, prototyping, and as a template for production-grade data platforms.

---

## Architecture/AWS Services Used

Below is the architecture diagram for the project.  

![Project Architecture](https://github.com/automationsaan/aws-devops-data-engineer-project/blob/main/project-pics/archtecture-2.png)

![AWS Services Used](https://github.com/automationsaan/aws-devops-data-engineer-project/blob/a058336db595e58a4d47592563c12407dfc0c1c9/project-pics/aws-services.png)

![AWS Services Used](https://github.com/automationsaan/aws-devops-data-engineer-project/blob/a058336db595e58a4d47592563c12407dfc0c1c9/project-pics/aws-services-2.png)

---

## Tools, Services, and Technologies Used

- **Streaming and Batch Ingestion**
  - AWS DMS (Database Migration Service)
  - AWS Schema Conversion Tool (manual/script integration)
  - Apache Kafka / Amazon MSK (Managed Streaming for Apache Kafka)
  - MSK Connect
  - Kinesis Data Streams
  - Kinesis Data Firehose
  - AWS Glue Schema Registry

- **Storage and Databases**
  - Amazon S3 (Data Lake)
  - Amazon EBS, Amazon EFS
  - AWS Backup
  - Amazon RDS, Amazon Aurora
  - Amazon DynamoDB, Amazon Neptune, Amazon DocumentDB, Amazon Timestream
  - AWS Lake Formation

- **Transforming and Processing**
  - AWS Glue (ETL, Schema Registry)
  - AWS Lambda
  - Amazon EC2, ECR, ECS, EKS, EMR, AWS Batch
  - Managed Service for Apache Flink

- **Analyse and Query**
  - Amazon Redshift (Data warehouse)
  - Amazon Athena (Ad-hoc querying)
  - Amazon OpenSearch Service (Search analytics)

- **Schedule and Orchestrate**
  - Amazon EventBridge
  - AWS Step Functions
  - Amazon MWAA (Managed Workflows for Apache Airflow)
  - AWS Glue Workflows
  - Amazon SNS, Amazon SQS, Amazon AppFlow

- **Consume and Visualise**
  - Amazon QuickSight (Business intelligence and dashboarding)
  - Amazon SageMaker (Machine Learning)

- **Operationalise, Maintain, and Monitor**
  - Amazon CloudWatch (Monitoring)
  - AWS CloudTrail (Auditing)
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
  - Bash scripts for automation
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

## Step-by-Step Setup Instructions

### 0. **Set Up Your AWS Account and AWS CLI**

#### a. **Create an AWS Account (if you don’t have one)**
- Go to [https://aws.amazon.com/](https://aws.amazon.com/) and click **Create an AWS Account**.
- Follow the prompts to set up your account, billing, and root user.

#### b. **Create an IAM User for CLI Access**
- Log in to the [AWS Console](https://console.aws.amazon.com/).
- Go to **IAM** > **Users** > **Add users**.
- Enter a username (e.g., `devops-user`).
- Select **Access key - Programmatic access**.
- Click **Next** and assign permissions (e.g., `AdministratorAccess` for full access, or custom policies for least privilege).
- Complete the steps and **download the `.csv` file** with your Access Key ID and Secret Access Key.

#### c. **Install AWS CLI**
- Download the AWS CLI for Windows: [AWS CLI v2 Download](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- Run the installer and follow the prompts.

**Verify installation in Git Bash:**
```sh
aws --version
```
You should see output like `aws-cli/2.x.x ...`

#### d. **Configure AWS CLI in Git Bash**

In Git Bash, run:
```sh
aws configure
```
You’ll be prompted for:
- **AWS Access Key ID:** (from your IAM user)
- **AWS Secret Access Key:** (from your IAM user)
- **Default region name:** (e.g., `us-east-1`)
- **Default output format:** (e.g., `json`)

**Verify:**  
```sh
aws sts get-caller-identity
```
You should see your AWS account and user information in JSON format.

---

### 1. **Clone the Repository**

```sh
git clone https://github.com/automationsaan/aws-devops-data-engineer-project.git
cd aws-devops-data-engineer-project
```
**Verify:**  
- Run `ls` or `dir` and confirm you see all project folders (e.g., `terraform/`, `docker/`, `jenkins-pipelines/`, etc.).

---

### 2. **Install Python Dependencies**

```sh
pip install -r requirements.txt
```
**Verify:**  
- Run `pip list` and check for packages like `boto3`, `pandas`, `awscli`, etc.
- Test with:
  ```sh
  python -c "import boto3, pandas; print('Python dependencies OK')"
  ```

---

### 3. **Provision AWS Infrastructure with Terraform (Initial Local State & State Migration)**

#### a. **Initial Apply Using Local State**

1. **Ensure the `backend "s3"` block in `main.tf` is commented out** (as shown in the code):
    ```terraform
    terraform {
      required_version = ">= 1.3.0"
      # backend "s3" {
      #   bucket = "my-terraform-state-bucket"
      #   key    = "state/aws-data-pipeline.tfstate"
      #   region = "us-east-1"
      # }
    }
    ```
2. Run:
    ```sh
    cd terraform
    terraform init
    terraform apply
    ```
    This will create all resources, including the S3 bucket for Terraform state.

#### b. **Migrate State to S3 Backend**

1. **Uncomment the `backend "s3"` block in `main.tf`** and set the bucket name, key, and region as needed.
2. Run:
    ```sh
    terraform init -migrate-state
    ```
    Terraform will prompt you to migrate your local state to S3. Type `yes` to confirm.

**Verify:**  
- Check the S3 bucket in the AWS Console. You should see a file like `state/aws-data-pipeline.tfstate`.
- Future Terraform operations will now use remote state in S3.

---

### 4. **Build and Run Jenkins (with Python dependencies)**

```sh
cd ../docker/jenkins
docker build -t custom-jenkins .
docker run -d -p 8080:8080 -v jenkins_home:/var/jenkins_home custom-jenkins
```
**Verify:**  
- Visit `http://localhost:8080` in your browser. Jenkins should be running.
- In Jenkins, run a shell step: `pip list` to confirm Python dependencies are available.

---

### 5. **Set Up Jenkins Pipelines**

- In Jenkins, create two pipelines:
  - **Infrastructure Pipeline:** Use `jenkins-pipelines/infrastructure-pipeline.groovy`
  - **Data Pipeline:** Use `jenkins-pipelines/data-pipeline.groovy`
- Set up AWS credentials in Jenkins (via environment variables or Jenkins credentials plugin).

**Verify:**  
- Run the infrastructure pipeline and check for successful Terraform output.
- Run the data pipeline and check for successful S3, Glue, DMS, and Lambda steps.

---

### 6. **Deploy Monitoring Stack (Prometheus & Grafana)**

**With Docker:**
```sh
cd ../../docker/prometheus
# Build and run Prometheus container as needed
cd ../grafana
# Build and run Grafana container as needed
```
**With Kubernetes:**
```sh
kubectl apply -f ../../kubernetes/prometheus/prometheus-deployment.yaml
kubectl apply -f ../../kubernetes/grafana/grafana-deployment.yaml
```
**Verify:**  
- Visit Grafana at `http://localhost:3000` (or your cluster endpoint).
- Log in (default: admin/admin), add Prometheus as a data source, and import the provided dashboard.

---

### 7. **Import Dashboards and Alert Rules**

- In Grafana, import `monitoring/dashboards/grafana-dashboard.json`.
- In Prometheus, load `monitoring/alerts/prometheus-alert.rules`.

**Verify:**  
- Grafana dashboard panels should show metrics (Jenkins, Lambda, Glue, etc.).
- Prometheus “Alerts” page should list your alert rules.

---

### 8. **Run and Monitor the Data Pipeline**

- Trigger the Jenkins data pipeline.
- Monitor S3 buckets, Glue jobs, DMS tasks, and Lambda invocations in the AWS Console.

**Verify:**  
- Data appears in S3 Silver bucket after pipeline run.
- Glue jobs and crawlers show as “Succeeded” in AWS Console.
- DMS task status is “Running” or “Succeeded.”
- Lambda function logs appear in CloudWatch.

---

### 9. **Monitor Everything in Grafana**

- Open Grafana and view the imported dashboard.

**Verify:**  
- You see live metrics for Jenkins builds, Lambda, Glue, DMS, and Redshift.
- Alerts trigger if thresholds are breached (simulate a failure to test).

---

### 10. **Provision AWS Secrets Manager and Amazon QuickSight**

- Secrets Manager is used to securely store DB credentials. The secret ARN is output after apply.
- Amazon QuickSight is provisioned for BI/dashboarding. You must enable QuickSight in the AWS Console before running Terraform for QuickSight resources.

---

## Requirements

- AWS account with sufficient permissions
- Terraform, AWS CLI, Docker, kubectl, Ansible installed locally
- Jenkins, Prometheus, Grafana (deployed via Docker or Kubernetes)
- Python 3.x (for Glue scripts, if needed)
- All Python dependencies installed via `requirements.txt`

---

## Additional Notes

- All infrastructure is managed as code for repeatability and auditability.
- IAM roles and policies are tightly scoped for security.
- Monitoring and alerting are integrated for proactive operations.
- Scripts in `scripts/` automate DMS, Redshift, and Lambda tasks.
- For production, review and adjust security, networking, and cost controls.
- The Jenkins Docker image is pre-configured to install all Python dependencies at build time for automation and consistency.
- **To enable all AWS services listed above, you may need to uncomment or add the corresponding Terraform resources in the `/terraform` directory. Some services (like MSK, Kinesis, Athena, OpenSearch, SageMaker, Lake Formation, etc.) are scaffolded for extensibility and can be enabled as your use case grows.**

---

## Troubleshooting

- Check Jenkins logs for pipeline errors.
- Use `terraform destroy` to tear down resources when done.
- Review AWS CloudWatch for service-specific logs.
- Ensure all AWS resource names are unique per account/region.

---

## License

MIT License

---

## Author

- Saan Saechao (AKA AutomationSaan)

---