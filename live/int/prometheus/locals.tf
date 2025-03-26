locals {
  cf_environment         = "int"
  environment            = "int"
  snowflake_environments = []
  blackbox_environments  = ["intr", "intm"]
  costcenter             = "datahub"
  owner                  = "datahub_devops@eulerhermes.com"
  product_name           = "datahub-monitoring"
}