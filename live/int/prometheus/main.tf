module "monitoring_infrastructure" {
  source = "../../../src/prometheus"

  cf_environment         = local.cf_environment
  environment            = local.environment
  snowflake_environments = local.snowflake_environments
  blackbox_environments  = local.blackbox_environments
  costcenter             = local.costcenter
  owner                  = local.owner
  product_name           = local.product_name
  log_retention_days     = 7

  providers = {
    aws         = aws
    aws.dr      = aws.dr
    aws.useast1 = aws.useast1
  }
}
