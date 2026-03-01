# Dokploy Outputs
output "dokploy_dashboard" {
  value = module.dokploy.dokploy_dashboard_url
}

output "dokploy_master_ips" {
  value = module.dokploy.dokploy_master_ips
}

output "dokploy_worker_ips" {
  value = module.dokploy.dokploy_worker_ips
}

# S3 Outputs
output "object_storage_namespace" {
  description = "Object Storage namespace"
  value       = module.s3.object_storage_namespace
}

output "standard_bucket_name" {
  description = "Name of the Standard tier bucket"
  value       = module.s3.standard_bucket_name
}

output "archive_bucket_name" {
  description = "Name of the Archive tier bucket"
  value       = module.s3.archive_bucket_name
}

output "standard_bucket_access_key_id" {
  description = "Access Key ID for Standard bucket S3 access"
  value       = module.s3.standard_bucket_access_key_id
  sensitive   = false
}

output "standard_bucket_secret_key" {
  description = "Secret Key for Standard bucket S3 access"
  value       = module.s3.standard_bucket_secret_key
  sensitive   = true
}

output "archive_bucket_access_key_id" {
  description = "Access Key ID for Archive bucket S3 access"
  value       = module.s3.archive_bucket_access_key_id
  sensitive   = false
}

output "archive_bucket_secret_key" {
  description = "Secret Key for Archive bucket S3 access"
  value       = module.s3.archive_bucket_secret_key
  sensitive   = true
}

output "s3_endpoint" {
  description = "S3-compatible endpoint for Object Storage"
  value       = module.s3.s3_endpoint
}

# Alert Outputs
output "budget_id" {
  description = "The OCID of the budget"
  value       = module.alert.budget_id
}

output "alert_rule_id" {
  description = "The OCID of the alert rule"
  value       = module.alert.alert_rule_id
}
