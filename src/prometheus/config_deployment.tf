# QUESTION: Should we create new API Key to avoid dependency with datahub-shared-infra
# project ? This will also probably make possible to segment our api access and revoke
# keys for each system (like here have a monitoring key that we can rotate and know that it
# will only cause problem for the monitoring) ?
data "aws_api_gateway_api_key" "shared_api_key" {
  id = module.datahub_shared_infra_main.data.api_gateway_api_key_id
}

data "aws_api_gateway_api_key" "team_api_keys" {
  for_each = module.datahub_shared_infra_main.data.api_gateway_api_key_ids
  id       = each.value
}

locals {
  team_names = [
    # WARN: route /isAlive of datahub-foundation can't be called concurrently.
    # Make sure blackbox on old stack is not activated for this team before
    # activating it here
    "datahub-foundation",
    "datahub-be",
    "datahub-bi",
    "datahub-mdm",
    "datahub-kpif",
  ]
  blackbox_config_object = {
    default_module_api_key = data.aws_api_gateway_api_key.shared_api_key.value
    team_api_keys = {
      for key_information in setproduct(var.blackbox_environments, local.team_names) :
      # NOTE: key_information[0] = environment name; key_information[1] = team name
      replace("${key_information[0]}-${key_information[1]}", "-", "_") =>
      data.aws_api_gateway_api_key.team_api_keys["${key_information[0]}-${key_information[1]}"].value
    }
    modules = [
      {
        prefix          = "http_2xx"
        method          = "GET"
        regexp_to_match = "^DOWN$"
      },
      {
        prefix          = "http_2xx_post"
        method          = "POST"
        regexp_to_match = "^DOWN$"
      },
      {
        prefix          = "http_2xx_warning"
        method          = "GET"
        regexp_to_match = "^WARNING$"
      },
    ]
  }
  blackbox_config_s3_key = "blackbox/config.yml"
}

# Prometheus
## Config is a template that we render + archive + upload to s3
data "archive_file" "prometheus_global_config" {
  type        = "zip"
  output_path = "artifacts/prometheus/templates/global_config.zip"
  source {
    content = templatefile("${path.module}/templates/prometheus.yml.tftpl", {
      scrape_snowflake_metrics                 = length(var.snowflake_environments) > 0 ? true : false,
      amazon_managed_prometheus_write_endpoint = "${aws_prometheus_workspace.datahub.prometheus_endpoint}api/v1/remote_write"
      aws_region                               = data.aws_region.current.name
      ALERTMANAGER_URLS                        = [for _, v in module.alertmanagers : v.dns_name]
      PUSHGATEWAY_URL                          = module.services["pushgateway"].dns_name
      CLOUDWATCH_URL                           = module.services["cloudwatch"].dns_name
      BLACKBOX_URL                             = module.services["blackbox"].dns_name
      RDS_EXPORTER_URL                         = module.services["rds-exporter"].dns_name
      SNOWFLAKE_URL                            = try(module.services["snowflake"].dns_name, "")
    })
    filename = "prometheus.base.yml" # prometheus_config_reloader expects `prometheus.base.yml` here
  }
}


resource "aws_s3_object" "prometheus_config" {
  bucket = module.prometheus_infra_bucket.id
  key    = "prometheus_global_config.zip"
  source = data.archive_file.prometheus_global_config.output_path
  etag   = data.archive_file.prometheus_global_config.output_md5
  tags   = local.common_tags
}

# Blackbox
resource "aws_s3_object" "blackbox_config" {
  bucket  = module.prometheus_infra_bucket.id
  key     = local.blackbox_config_s3_key
  content = templatefile("${path.module}/templates/blackbox.yml.tftpl", local.blackbox_config_object)
  tags    = local.common_tags
}
