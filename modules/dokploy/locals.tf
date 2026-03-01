# Instance config
locals {
  # Oracle Cloud Free Tier limits
  max_ocpus_total      = 4
  max_memory_gbs_total = 24
  instance_shape       = "VM.Standard.A1.Flex" # Free tier eligible shape

  # Availability domain distribution (even spread across all ADs)
  # Masters and workers are distributed separately and evenly
  num_availability_domains = length(data.oci_identity_availability_domains.ads.availability_domains)

  # List of AD names for master instances (even distribution across all available ADs)
  # Formula: floor(idx * num_ads / num_master_instances) ensures even spread
  master_availability_domains = var.num_master_instances > 0 ? [
    for idx in range(var.num_master_instances) :
    data.oci_identity_availability_domains.ads.availability_domains[
      floor(idx * local.num_availability_domains / var.num_master_instances)
    ].name
  ] : []

  # List of AD names for worker instances (even distribution across all available ADs)
  # Formula: floor(idx * num_ads / num_worker_instances) ensures even spread
  worker_availability_domains = var.num_worker_instances > 0 ? [
    for idx in range(var.num_worker_instances) :
    data.oci_identity_availability_domains.ads.availability_domains[
      floor(idx * local.num_availability_domains / var.num_worker_instances)
    ].name
  ] : []

  # SSH key: read from file path
  ssh_authorized_keys = file(var.ssh_public_key_path)

  instance_config = {
    is_pv_encryption_in_transit_enabled = true
    ssh_authorized_keys                 = local.ssh_authorized_keys
    shape                               = local.instance_shape
    shape_config = {
      memory_in_gbs = floor(local.max_memory_gbs_total / (var.num_worker_instances + var.num_master_instances))
      ocpus         = floor(local.max_ocpus_total / (var.num_worker_instances + var.num_master_instances))
    }
    source_details = {
      source_id               = data.oci_core_images.ubuntu_images.images[0].id
      source_type             = "image"
      boot_volume_size_in_gbs = floor(200 / var.num_worker_instances)
    }
    availability_config = {
      recovery_action = "RESTORE_INSTANCE"
    }
    instance_options = {
      are_legacy_imds_endpoints_disabled = false
    }
  }
}
