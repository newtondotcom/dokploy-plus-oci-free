terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 6.22.0"
    }
  }
}

# S3 Module
module "s3" {
  source = "./modules/s3"

  tenancy_ocid = var.tenancy_ocid
  user_ocid    = var.user_ocid
  region       = var.region
}

# Alert Module
module "alert" {
  source = "./modules/alert"

  tenancy_ocid = var.tenancy_ocid
  alert_email  = var.alert_email
}

# Dokploy Module
module "dokploy" {
  source = "./modules/dokploy"

  tenancy_ocid         = var.tenancy_ocid
  region               = var.region
  ssh_public_key_path  = var.ssh_public_key_path
  num_master_instances = var.num_master_instances
  num_worker_instances = var.num_worker_instances
}
