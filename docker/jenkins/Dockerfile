# This Dockerfile builds a Jenkins image with Python 3, pip, and all project Python dependencies pre-installed.
# This setup allows Jenkins jobs to run Python scripts (e.g., for AWS automation, ETL, testing) out-of-the-box.

FROM jenkins/jenkins:lts

USER root  # Switch to root to install system packages

# Install Python 3 and pip for Jenkins jobs that require Python scripting
RUN apt-get update && \
    apt-get install -y python3 python3-pip && \
    rm -rf /var/lib/apt/lists/*

# Copy requirements.txt from the project root into the image
# This ensures all Python dependencies needed for ETL, AWS automation, and testing are available in Jenkins jobs
COPY ../../requirements.txt /tmp/requirements.txt

# Install all Python dependencies listed in requirements.txt globally
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt

# Install required Jenkins plugins via install-plugins.sh (CLI)
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

USER jenkins  # Switch back to Jenkins user for security

# Notes:
# - Python 3, pip, and all project Python dependencies are available for any Jenkins job.
# - This makes the CI/CD environment consistent and reduces setup time for each build.
# - Adjust the COPY path if your build context changes.
# - Further customization can be added as needed.
