// MANDATORY FOR OCI PROVIDER

variable "tenancy_ocid" {
  description = "The OCID of the compartment. Find it: Profile → Tenancy: youruser → Tenancy information → OCID https://cloud.oracle.com/tenancy"
  type        = string
}

variable "user_ocid" {
  description = "OCI user OCID"
  type        = string
}

variable "fingerprint" {
  description = "Fingerprint of the API key"
  type        = string
}

variable "private_key_path" {
  description = "Path to the private API key"
  type        = string
  default     = "./user/oci_api_key.pem"
}

variable "region" {
  description = "OCI region"
  type        = string
  default     = "eu-paris-1"
}

// DOKPLOY RELATED VARIABLES

variable "ssh_public_key_path" {
  description = "Path to the SSH public key to access the instances after"
  type        = string
  default     = "./user/vm_ssh_key.pub"
}

variable "num_master_instances" {
  description = "Number of Dokploy master instances to deploy : DOKPLOY ONLY SUPPORT ONE MASTER FOR NOW."
  type        = number
  default     = 1
}

variable "num_worker_instances" {
  description = "Number of Dokploy worker instances to deploy."
  type        = number
  default     = 1
}

variable "alert_email" {
  description = "Email address you cant to be alerted if you are being charged by Oracle"
  type        = string
}
