locals {
  cf_environment         = "uat"
  environment            = "uat"
  snowflake_environments = ["uatr", "uatm"]
  blackbox_environments  = ["uatr", "uatrd", "uatqmt", "uatm", "uatp"]
  costcenter             = "datahub"
  owner                  = "datahub_devops@eulerhermes.com"
  product_name           = "datahub-monitoring"
}