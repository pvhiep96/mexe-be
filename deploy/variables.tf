# variables.tf

# ------------------------------
# General settings
# ------------------------------

variable "region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "ap-southeast-1"
}

variable "project" {
  description = "Project name prefix for tagging resources"
  type        = string
  default     = "mexe"
}

# ------------------------------
# IAM User settings
# ------------------------------

variable "deploy_user_name" {
  description = "IAM username for deployment"
  type        = string
  default     = "ubuntu"
}

variable "deploy_policy_actions" {
  description = "List of allowed IAM actions for deploy user"
  type        = list(string)
  default = [
    "ec2:*",
    "iam:PassRole",
    "s3:*",
    "ssm:GetParameter",
    "secretsmanager:GetSecretValue"
  ]
}

# ------------------------------
# EC2 settings
# ------------------------------

variable "ami_id" {
  description = "AMI ID created by Packer"
  type        = string
  default     = "ami-0945c0fa1e8166bd0"
}

variable "instance_type" {
  description = "Instance type for the EC2 app server"
  type        = string
  default     = "t3.small"
}

# variable "ssh_key_name" {
#   description = "Name of the SSH key pair to use for EC2 access"
#   type        = string
# }

# ------------------------------
# Secrets
# ------------------------------

# variable "secrets_manager_name" {
#   description = "Name of the AWS Secrets Manager secret for database/app credentials"
#   type        = string
#   default     = "prod/rails"
# }
