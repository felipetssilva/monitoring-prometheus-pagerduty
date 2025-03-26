# We want to store routing keys inside SSM (consumed as a secret by alertmanager)
# Routing keys are provided encrypted for privacy reasons and we need to unencrypt
# them first as aws_ssm_parameter expect clear values. Result is reencrypted on
# the fly with the same key id
data "aws_kms_secrets" "unencrypted_pagerduty_routing_keys" {
  count = length(var.encrypted_pagerduty_routing_keys) > 0 ? 1 : 0
  dynamic "secret" {
    for_each = var.encrypted_pagerduty_routing_keys

    content {
      name    = secret.key
      payload = secret.value
    }
  }
}