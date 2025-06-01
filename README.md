# AWS DevOps Data Engineer Project

## Project Overview

This project demonstrates a modern, end-to-end data engineering pipeline on AWS, fully automated with DevOps best practices. It covers the ingestion, transformation, and loading of data using AWS services, with infrastructure managed as code and CI/CD pipelines for both infrastructure and data workflows. The project leverages Python data and automation libraries (see `requirements.txt`) for ETL, orchestration, and monitoring tasks. The project is designed for learning, prototyping, and as a template for production-grade data platforms.

---

## Architecture/AWS Services Used

Below is the architecture diagram for the project.  
**(Replace the image path with your actual image file in the `projects-pics` folder.)**

![Project Architecture](https://github.com/automationsaan/aws-devops-data-engineer-project/blob/main/project-pics/archtecture-2.png)

![AWS Services Used](https://github.com/automationsaan/aws-devops-data-engineer-project/blob/a058336db595e58a4d47592563c12407dfc0c1c9/project-pics/aws-services.png)

![AWS Services Used](https://github.com/automationsaan/aws-devops-data-engineer-project/blob/a058336db595e58a4d47592563c12407dfc0c1c9/project-pics/aws-services-2.png)

---

## Tools, Services, and Technologies Used

- **AWS Services**
  - S3 (Data Lake - Bronze & Silver buckets)
  - Glue (ETL jobs, Crawlers, Data Catalog)
  - DMS (Database Migration Service for data replication)
  - Lambda (Serverless post-processing)
  - Redshift (Data warehouse)
  - IAM (Access control)
  - RDS (Relational Database Service)
  - VPC (Networking)
- **DevOps & Automation**
  - Terraform (Infrastructure as Code)
  - Jenkins (CI/CD pipelines)
  - Ansible (Configuration management)
  - Docker (Containerization for Jenkins, Prometheus, Grafana)
  - Kubernetes (Orchestration for Jenkins, Prometheus, Grafana)
- **Monitoring & Alerting**
  - Prometheus (Metrics collection)
  - Grafana (Dashboards & visualization)
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
├── docker/
├── kubernetes/
├── terraform/
├── jenkins-pipelines/
├── monitoring/
├── scripts/
├── projects-pics/
├── .gitignore
├── README.md
└── requirements.txt
```

---

## Step-by-Step Setup Instructions

### 1. **Clone the Repository**

```bash
git clone https://github.com/your-org/aws-devops-data-engineer-project.git
cd aws-devops-data-engineer-project
```

---

### 2. **Install Python Dependencies**

- Ensure you have Python 3 and pip installed.
- Install all required Python packages for ETL, automation, and monitoring:

```bash
pip install -r requirements.txt
```

---

### 3. **Provision AWS Infrastructure with Terraform**

- Ensure you have [Terraform](https://www.terraform.io/downloads.html) and [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) installed and configured (`aws configure`).
- Navigate to the Terraform directory and initialize:

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

- This will create S3 buckets, Glue resources, IAM roles, RDS, Redshift, VPC, and other AWS resources.

---

### 4. **Set Up Jenkins for CI/CD**

- Use the provided Dockerfile or Kubernetes manifests to deploy Jenkins:

**With Docker:**
```bash
cd ../docker/jenkins
docker build -t custom-jenkins .
docker run -d -p 8080:8080 -v jenkins_home:/var/jenkins_home custom-jenkins
```
  - The Jenkins Docker image automatically installs all Python dependencies from `requirements.txt` so your jobs can run Python scripts out-of-the-box.

**With Kubernetes:**
```bash
kubectl apply -f ../../kubernetes/jenkins/jenkins-deployment.yaml
```

- Use Ansible playbooks in `ansible/playbooks/` for automated Jenkins setup if desired.

---

### 5. **Configure Jenkins Pipelines**

- In Jenkins, create two pipelines:
  - **Infrastructure Pipeline:** Use `jenkins-pipelines/infrastructure-pipeline.groovy`
  - **Data Pipeline:** Use `jenkins-pipelines/data-pipeline.groovy`
- Set up AWS credentials in Jenkins (using environment variables or Jenkins credentials plugin).

---

### 6. **Deploy Monitoring Stack (Prometheus & Grafana)**

- **With Docker:**
  - Use the provided Dockerfiles in `docker/prometheus` and `docker/grafana`.
- **With Kubernetes:**
  - Apply manifests in `kubernetes/prometheus` and `kubernetes/grafana`.

- Import the provided Grafana dashboard (`monitoring/dashboards/grafana-dashboard.json`) and set up Prometheus alert rules (`monitoring/alerts/prometheus-alert.rules`).

---

### 7. **Run the Data Pipeline**

- Trigger the Jenkins data pipeline. It will:
  - Ingest data to S3 (Bronze)
  - Run Glue Crawler and ETL job
  - Replicate data with DMS
  - Trigger Lambda for post-processing

---

### 8. **Monitor and Visualize**

- Access Grafana (default: `http://localhost:3000` or your Kubernetes service endpoint).
- Use the dashboard to monitor pipeline health, job durations, resource usage, and alerts.

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

## Authors

- Saan Saechao (AKA AutomationSaan)

---