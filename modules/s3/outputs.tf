output "object_storage_namespace" {
  description = "Object Storage namespace"
  value       = data.oci_objectstorage_namespace.namespace.namespace
}

output "standard_bucket_name" {
  description = "Name of the Standard tier bucket"
  value       = oci_objectstorage_bucket.standard_bucket.name
}

output "archive_bucket_name" {
  description = "Name of the Archive tier bucket"
  value       = oci_objectstorage_bucket.archive_bucket.name
}

output "standard_bucket_access_key_id" {
  description = "Access Key ID for Standard bucket S3 access"
  value       = oci_identity_customer_secret_key.standard_bucket_key.id
  sensitive   = false
}

output "standard_bucket_secret_key" {
  description = "Secret Key for Standard bucket S3 access (save this securely, it won't be shown again)"
  value       = nonsensitive(oci_identity_customer_secret_key.standard_bucket_key.key)
  sensitive   = true
}

output "archive_bucket_access_key_id" {
  description = "Access Key ID for Archive bucket S3 access"
  value       = oci_identity_customer_secret_key.archive_bucket_key.id
  sensitive   = false
}

output "archive_bucket_secret_key" {
  description = "Secret Key for Archive bucket S3 access (save this securely, it won't be shown again)"
  value       = nonsensitive(oci_identity_customer_secret_key.archive_bucket_key.key)
  sensitive   = true
}

output "s3_endpoint" {
  description = "S3-compatible endpoint for Object Storage"
  value       = "https://${data.oci_objectstorage_namespace.namespace.namespace}.compat.objectstorage.${var.region}.oraclecloud.com"
}
