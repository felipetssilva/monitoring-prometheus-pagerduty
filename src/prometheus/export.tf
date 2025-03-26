module "datahub_monitoring_infra" {
  source = "git::ssh://git@gitlab.eulerhermes.io/deployment/datahub/terraform-modules/shared-output.git//export?ref=v1.2.2"

  environment = var.environment
  project     = "datahub-monitoring-infra"
  data = {
    pushgateway_url                          = module.services["pushgateway"].dns_name
    config_reloader_bucket_name              = module.prometheus_infra_bucket.id
    config_reloader_prometheus_bucket_prefix = "prometheus/"
    config_reloader_cloudwatch_bucket_prefix = "cloudwatch/"
  }

  tags = local.common_tags
}
