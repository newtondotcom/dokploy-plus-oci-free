# Random resource ID
resource "random_string" "resource_code" {
  length  = 5
  special = false
  upper   = false
}

# Fetch Ubuntu Images (ou Oracle Linux)
data "oci_core_images" "ubuntu_images" {
  tenancy_ocid           = var.tenancy_ocid
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "24.04"
  shape                    = local.instance_shape
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

# Fetch Availability Domains
data "oci_identity_availability_domains" "ads" {
  tenancy_ocid = var.tenancy_ocid
}