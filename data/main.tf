provider "aws" {
  region = var.aws_region
}

# S3 Bucket for source data
resource "aws_s3_bucket" "source_data_bucket" {
  bucket = "${var.project_name}-source-data"
  acl    = "private"
}

# S3 Bucket for transformed data
resource "aws_s3_bucket" "transformed_data_bucket" {
  bucket = "${var.project_name}-transformed-data"
  acl    = "private"
}

# Secrets Manager for storing database secrets
resource "aws_secretsmanager_secret" "db_credentials" {
  name = "${var.project_name}-db-credentials"
  description = "Database credentials for the ETL job"
}

resource "aws_secretsmanager_secret_version" "db_credentials_version" {
  secret_id     = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password
    database = var.db_name
  })
}

# Glue Database
resource "aws_glue_catalog_database" "data_pipeline_db" {
  name = "${var.project_name}_database"
}

# Glue Crawler for source data
resource "aws_glue_crawler" "source_data_crawler" {
  name         = "${var.project_name}_source_data_crawler"
  database_name = aws_glue_catalog_database.data_pipeline_db.name
  role         = var.glue_role_arn

  s3_target {
    path = "s3://${aws_s3_bucket.source_data_bucket.bucket}"
  }
}

# Glue ETL Job
resource "aws_glue_job" "etl_job" {
  name     = "${var.project_name}_etl_job"
  role_arn = var.glue_role_arn

  command {
    name            = "glueetl"
    script_location = "s3://${aws_s3_bucket.source_data_bucket.bucket}/scripts/etl_script.py"
    python_version  = "3"
  }

  default_arguments = {
    "--TempDir"          = "s3://${aws_s3_bucket.transformed_data_bucket.bucket}/temp/"
    "--source_bucket"    = aws_s3_bucket.source_data_bucket.bucket
    "--target_bucket"    = aws_s3_bucket.transformed_data_bucket.bucket
    "--DB_NAME"          = aws_glue_catalog_database.data_pipeline_db.name
  }

  max_retries      = 1
  timeout          = 2880
  max_capacity     = 2
  glue_version     = "2.0"
}

# Glue Crawler for transformed data
resource "aws_glue_crawler" "transformed_data_crawler" {
  name         = "${var.project_name}_transformed_data_crawler"
  database_name = aws_glue_catalog_database.data_pipeline_db.name
  role         = var.glue_role_arn

  s3_target {
    path = "s3://${aws_s3_bucket.transformed_data_bucket.bucket}"
  }
}
