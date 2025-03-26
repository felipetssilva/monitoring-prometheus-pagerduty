
resource "aws_ssm_parameter" "encrypted_pagerduty_routing_keys" {
  for_each = local.unencrypted_pagerduty_routing_keys
  value    = each.value
  name     = "/${var.environment}/datahub/monitoring/${lower(each.key)}"
  key_id   = module.securitydata.s3_key_target_key_arn
  type     = "SecureString"
  tags     = local.common_tags
}

# FIXME : Delete block below after migration
data "aws_ssm_parameter" "encrypted_pagerduty_routing_keys" {
  for_each = var.environment == "prod" ? local.unencrypted_pagerduty_routing_keys : {}
  name     = "/${var.environment}/datahub/monitoring/${lower(each.key)}"
}