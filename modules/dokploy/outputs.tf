output "dokploy_dashboard_url" {
  description = "URL to access Dokploy dashboard"
  value       = var.num_master_instances > 0 ? "http://${oci_core_instance.dokploy_main[0].public_ip}:3000/ (wait 3-5 minutes to finish Dokploy installation)" : null
}

output "dokploy_master_ips" {
  description = "Public IPs of master instances"
  value       = [for instance in oci_core_instance.dokploy_main : instance.public_ip]
}

output "dokploy_worker_ips" {
  description = "Public IPs of worker instances"
  value       = [for instance in oci_core_instance.dokploy_worker : "${instance.public_ip} (use it to add the server in Dokploy Dashboard)"]
}

output "vcn_id" {
  description = "VCN ID"
  value       = oci_core_vcn.dokploy_vcn.id
}

output "subnet_id" {
  description = "Subnet ID"
  value       = oci_core_subnet.dokploy_subnet.id
}
