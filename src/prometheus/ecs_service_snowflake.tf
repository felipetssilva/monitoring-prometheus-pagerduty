locals {
  snowflake_ecs_task_definition = length(var.snowflake_environments) == 0 ? null : {
    snowflake = {
      image_name                    = "datahub/snowflake-prometheus-exporter"
      image_tag                     = var.cf_environment
      container_port                = 9120
      cpu                           = 256
      memory                        = 512
      task_role_arn                 = module.snowflake[0].aws_iam_role_arn
      health_check_endpoint         = "/healthcheck"
      additional_security_group_ids = [module.snowflake[0].snowflake_sg]
      environment = [
        {
          name = "SNOWFLAKE_VARIABLES",
          value = jsonencode({
            for environment in var.snowflake_environments : environment => {
              ENV                    = environment
              SNOWFLAKE_URL          = "altnazdrleia-${var.cf_environment}.privatelink"
              SNOWFLAKE_USER         = "SNWU_${upper(environment)}_MONITOR"
              SNOWFLAKE_ROLE         = module.snowflake[0].snowflake_role[environment].data.roles["MONITOR"]
              SNOWFLAKE_WAREHOUSE    = module.snowflake[0].snowflake_warehouse[environment].data.warehouses["MONITOR"]
              SNOWFLAKE_DATABASE     = module.snowflake[0].snowflake_database[environment].data.monitor_database_name
              SSM_SNOWFLAKE_PASSWORD = "/${environment}/datahub/snowflake/password/snwu_${environment}_monitor"
            }
          })
        },
        {
          name  = "AWS_DEFAULT_REGION",
          value = data.aws_region.current.name
        },
        {
          name  = "SENTRY_DSN",
          value = "https://fd7e1038ab3e44fd953c8b8b5d407bfa@sentry.infra.eulerhermes.io/11"
        }
      ]
    }
  }
}

# Snowflake specific resources are created inside a dedicated module to manage
# envs where snowflake is not deployed
module "snowflake" {
  source = "./modules/snowflake"
  count  = length(var.snowflake_environments) > 0 ? 1 : 0

  environment            = var.environment
  cf_environment         = var.cf_environment
  costcenter             = var.costcenter
  snowflake_environments = var.snowflake_environments
  owner                  = var.owner
  product_name           = var.product_name
  service_name           = "snowflake" # must match local.snowflake_service.key

  vpc_id                      = module.networkdata.vpc_id
  iam_role_assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
  kms_key_arn                 = module.securitydata.s3_key_target_key_arn
}