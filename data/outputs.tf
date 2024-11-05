output "source_data_bucket" {
  description = "S3 bucket for source data"
  value       = aws_s3_bucket.source_data_bucket.bucket
}

output "transformed_data_bucket" {
  description = "S3 bucket for transformed data"
  value       = aws_s3_bucket.transformed_data_bucket.bucket
}

output "glue_db_name" {
  description = "Glue Database Name"
  value       = aws_glue_catalog_database.data_pipeline_db.name
}

output "secret_arn" {
  description = "Secrets Manager ARN for database credentials"
  value       = aws_secretsmanager_secret.db_credentials.arn
}
