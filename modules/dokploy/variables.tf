variable "tenancy_ocid" {
  description = "The OCID of the compartment"
  type        = string
}

variable "region" {
  description = "OCI region"
  type        = string
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key to access the instances"
  type        = string
}

variable "num_master_instances" {
  description = "Number of Dokploy master instances to deploy"
  type        = number
}

variable "num_worker_instances" {
  description = "Number of Dokploy worker instances to deploy"
  type        = number
}
