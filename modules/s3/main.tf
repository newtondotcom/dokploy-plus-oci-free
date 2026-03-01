# Retrieve Object Storage namespace
data "oci_objectstorage_namespace" "namespace" {
  compartment_id = var.tenancy_ocid
}

# Object Storage Bucket - Standard tier
resource "oci_objectstorage_bucket" "standard_bucket" {
  compartment_id = var.tenancy_ocid
  namespace      = data.oci_objectstorage_namespace.namespace.namespace
  name           = "objectstorage-bucket-standard"
  storage_tier   = "Standard"
}

# Object Storage Bucket - Archive tier
resource "oci_objectstorage_bucket" "archive_bucket" {
  compartment_id = var.tenancy_ocid
  namespace      = data.oci_objectstorage_namespace.namespace.namespace
  name           = "objectstorage-bucket-archive"
  storage_tier   = "Archive"
}

# Customer Secret Key for Standard bucket S3 access
resource "oci_identity_customer_secret_key" "standard_bucket_key" {
  user_id      = var.user_ocid
  display_name = "standard-bucket-s3-access-key"
}

# Customer Secret Key for Archive bucket S3 access
resource "oci_identity_customer_secret_key" "archive_bucket_key" {
  user_id      = var.user_ocid
  display_name = "archive-bucket-s3-access-key"
}
