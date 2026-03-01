resource "oci_budget_budget" "one_cent_budget" {
  compartment_id = var.compartment_id
  target_type    = "COMPARTMENT"
  targets        = [var.compartment_id]

  amount       = 1
  reset_period = "MONTHLY"

  description  = "Alert when spending reaches $0.01"
  display_name = "one-cent_billing_alarm"
}

resource "oci_budget_alert_rule" "one_cent_alert" {
  budget_id = oci_budget_budget.one_cent_budget.id

  type           = "ACTUAL"
  threshold      = 1
  threshold_type = "PERCENTAGE"

  description  = "Triggered when OCI charges reach $0.01"
  display_name = "charge_detected_alert"

  message = "⚠️ OCI billing alert: spending has started (>$0.00)."

  recipients = var.git_email
}