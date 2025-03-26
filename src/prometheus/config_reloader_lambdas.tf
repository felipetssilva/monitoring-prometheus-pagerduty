locals {
  config_reloaders = {
    prometheus = {
      equivalent_ecs_service = "prometheus"
      handler_name           = "handler"
      environment = {
        # TODO: config reloader must use CONFIG_RELOAD_ENDPOINT, more generally normalize env var
        # CONFIG_RELOAD_ENDPOINT = "https://${module.services[each.value.equivalent_ecs_service].dns_name}/-/reload"
        # prom part
        PROM_URL          = "https://${module.services["prometheus"].dns_name}/-/reload"
        PROMTOOL_PATH     = "/opt/promtool"
        EFS_PATH          = "/mnt/efs"
        PUSHGATEWAY_URL   = module.services["pushgateway"].dns_name
        CLOUDWATCH_URL    = module.services["cloudwatch"].dns_name
        BLACKBOX_URL      = module.services["blackbox"].dns_name
        YACE_URL          = ""
        SNOWFLAKE_URL     = try(module.services["snowflake"].dns_name, "")
        ALERTMANAGER_URLS = join(";", [for _, v in module.alertmanagers : v.dns_name])
        SENTRY_DSN        = "https://7a8295f8292142278241364e9d076889@sentry.infra.eulerhermes.io/41"
      }
      trigger_lambda_on_filter_suffix = ".zip"
    }
    blackbox = {
      equivalent_ecs_service = "blackbox"
      handler_name           = "handler_blackbox"
      environment = {
        BLACKBOX_CONFIG_PATH = "/mnt/efs/config.yml"
        BLACKBOX_RELOAD_URL  = "https://${module.services["blackbox"].dns_name}/-/reload"
        SENTRY_DSN           = "https://49b04364cb8b44608a5c2d08e8ec07b2@sentry.infra.eulerhermes.io/71"
        # Defines bucket name & path where blackbox conf is stored
        BUCKET_NAME = module.prometheus_infra_bucket.id
        OBJECT_KEY  = aws_s3_object.blackbox_config.key
      }
      trigger_lambda_on_filter_suffix = basename(local.blackbox_config_s3_key)
    }
    cloudwatch = {
      equivalent_ecs_service = "cloudwatch"
      handler_name           = "handler_cloudwatch"
      environment = {
        EFS_PATH        = "/mnt/efs"
        CONFIG_PREFIX   = "cloudwatch/"
        RELOAD_ENDPOINT = "https://${module.services["cloudwatch"].dns_name}/-/reload"
        SENTRY_DSN      = "https://269df7e9bcc14a0da143fd3cfb8cd492@sentry.infra.eulerhermes.io/57"
        LOGLEVEL        = "DEBUG"
      }
      trigger_lambda_on_filter_suffix = ".zip"
    }
  }

  config_reloader_source_core       = "${path.root}/artifacts/prometheus_config_reloader-${var.environment}.zip"
  promtool_lambda_layer_source_code = "${path.root}/artifacts/prometheus_config_reloader-promtool-${var.environment}.zip"
}

resource "aws_s3_bucket_notification" "main" {
  bucket = module.prometheus_infra_bucket.id

  # Trigger config reloader for prometheus base conf modification
  lambda_function {
    lambda_function_arn = module.lambda_config_reloaders["prometheus"].arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "./"
    filter_suffix       = "prometheus_global_config.zip"
  }

  # Trigger config reloader (folder-specific for the different handlers)
  dynamic "lambda_function" {
    for_each = local.config_reloaders
    content {
      lambda_function_arn = module.lambda_config_reloaders[lambda_function.key].arn
      events              = ["s3:ObjectCreated:*"]
      filter_suffix       = lambda_function.value.trigger_lambda_on_filter_suffix
      filter_prefix       = lambda_function.key
    }
  }

  depends_on = [aws_lambda_permission.lambda_config_reloaders]
}

resource "aws_s3_object" "lambda_config_reloaders" {
  bucket      = module.prometheus_infra_bucket.id
  key         = "lambda_code/prometheus_config_reloader.zip"
  source      = local.config_reloader_source_core
  source_hash = filesha256(local.config_reloader_source_core)
  tags        = local.common_tags
}
