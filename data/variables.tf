variable "aws_region" {
  description = "AWS region for resources"
  type        = string
}

variable "project_name" {
  description = "Project name for naming resources"
  type        = string
}

variable "glue_role_arn" {
  description = "ARN of the IAM role for AWS Glue to use"
  type        = string
}

variable "db_username" {
  description = "Database username for AWS Glue job"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Database password for AWS Glue job"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Database name for AWS Glue job"
  type        = string
}
