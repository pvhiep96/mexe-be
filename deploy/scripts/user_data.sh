#!/bin/bash
set -euo pipefail
# Install aws-cli v2 if not included (packer may have installed), ensure docker permissions
# Pull secrets from AWS Secrets Manager or SSM
AWS_REGION="${aws_region}"
SECRET_NAME="${secrets_manager_name}" # e.g. my/rails/prod

# Pull docker-compose.yml and app config from S3 or git (choose one)
APP_DIR=/opt/rails-app
if [ ! -d "$APP_DIR" ]; then
  mkdir -p "$APP_DIR"
  chown ec2-user:ec2-user "$APP_DIR"
fi

# # Example: fetch docker-compose from S3
# aws s3 cp s3://my-bucket/infra/docker-compose.yml $APP_DIR/docker-compose.yml --region "$AWS_REGION"
# aws s3 cp s3://my-bucket/infra/nginx.conf $APP_DIR/nginx.conf --region "$AWS_REGION"

# Start docker-compose via systemd service
sudo systemctl start rails-docker.service
