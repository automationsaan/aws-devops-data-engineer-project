# AWS DevOps Data Engineer Project

## Project Overview

This project demonstrates a modern, end-to-end data engineering pipeline on AWS, fully automated with DevOps best practices. It covers the ingestion, transformation, and loading of data using AWS services, with infrastructure managed as code and CI/CD pipelines for both infrastructure and data workflows. The project leverages Python data and automation libraries (see `requirements.txt`) for ETL, orchestration, and monitoring tasks. The project is designed for learning, prototyping, and as a template for production-grade data platforms.

---

## Architecture/AWS Services Used

Below is the architecture diagram for the project.  

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

### 3. **Configure AWS CLI**

```sh
aws configure
```
**Verify:**  
- Run `aws sts get-caller-identity` to confirm your credentials are working.

---

### 4. **Provision AWS Infrastructure with Terraform**

```sh
cd terraform
terraform init
terraform plan
terraform apply
```
**Verify:**  
- After `terraform apply`, check the AWS Console for S3 buckets, Glue, IAM roles, etc.
- Run `terraform state list` to see managed resources.

---

### 5. **Build and Run Jenkins (with Python dependencies)**

```sh
cd ../docker/jenkins
docker build -t custom-jenkins .
docker run -d -p 8080:8080 -v jenkins_home:/var/jenkins_home custom-jenkins
```
**Verify:**  
- Visit `http://localhost:8080` in your browser. Jenkins should be running.
- In Jenkins, run a shell step: `pip list` to confirm Python dependencies are available.

---

### 6. **Set Up Jenkins Pipelines**

- In Jenkins, create two pipelines:
  - **Infrastructure Pipeline:** Use `jenkins-pipelines/infrastructure-pipeline.groovy`
  - **Data Pipeline:** Use `jenkins-pipelines/data-pipeline.groovy`
- Set up AWS credentials in Jenkins (via environment variables or Jenkins credentials plugin).

**Verify:**  
- Run the infrastructure pipeline and check for successful Terraform output.
- Run the data pipeline and check for successful S3, Glue, DMS, and Lambda steps.

---

### 7. **Deploy Monitoring Stack (Prometheus & Grafana)**

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

### 8. **Import Dashboards and Alert Rules**

- In Grafana, import `monitoring/dashboards/grafana-dashboard.json`.
- In Prometheus, load `monitoring/alerts/prometheus-alert.rules`.

**Verify:**  
- Grafana dashboard panels should show metrics (Jenkins, Lambda, Glue, etc.).
- Prometheus “Alerts” page should list your alert rules.

---

### 9. **Run and Monitor the Data Pipeline**

- Trigger the Jenkins data pipeline.
- Monitor S3 buckets, Glue jobs, DMS tasks, and Lambda invocations in the AWS Console.

**Verify:**  
- Data appears in S3 Silver bucket after pipeline run.
- Glue jobs and crawlers show as “Succeeded” in AWS Console.
- DMS task status is “Running” or “Succeeded.”
- Lambda function logs appear in CloudWatch.

---

### 10. **Monitor Everything in Grafana**

- Open Grafana and view the imported dashboard.

**Verify:**  
- You see live metrics for Jenkins builds, Lambda, Glue, DMS, and Redshift.
- Alerts trigger if thresholds are breached (simulate a failure to test).

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