output "budget_id" {
  description = "The OCID of the budget"
  value       = oci_budget_budget.one_cent_budget.id
}

output "alert_rule_id" {
  description = "The OCID of the alert rule"
  value       = oci_budget_alert_rule.one_cent_alert.id
}
