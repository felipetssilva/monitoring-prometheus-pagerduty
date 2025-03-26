module "networkdata" {
  source      = "git::ssh://git@gitlab.eulerhermes.io/cloud-devops/terraform-modules/networkdata.git?ref=v2.0.3"
  environment = var.cf_environment
  resources   = ["nat2", "networking", "shared"]
}

module "snowflake_role" {
  source      = "git::ssh://git@gitlab.eulerhermes.io/deployment/datahub/terraform-modules/shared-output.git//import?ref=v1.2.2"
  for_each    = toset(var.snowflake_environments)
  environment = each.key
  project     = "snowflake_role"
}

module "snowflake_warehouse" {
  source      = "git::ssh://git@gitlab.eulerhermes.io/deployment/datahub/terraform-modules/shared-output.git//import?ref=v1.2.2"
  for_each    = toset(var.snowflake_environments)
  environment = each.key
  project     = "snowflake_warehouse"
}

module "snowflake_database" {
  source      = "git::ssh://git@gitlab.eulerhermes.io/deployment/datahub/terraform-modules/shared-output.git//import?ref=v1.2.2"
  for_each    = toset(var.snowflake_environments)
  environment = each.key
  project     = "snowflake_database"
}

module "snowflake_privatelink" {
  source      = "git::ssh://git@gitlab.eulerhermes.io/deployment/datahub/terraform-modules/shared-output.git//import?ref=v1.2.2"
  count       = length(var.snowflake_environments) > 0 ? 1 : 0
  environment = var.environment
  project     = "snowflake_privatelink"
}

data "aws_prefix_list" "prefix_list_s3" {
  name = "com.amazonaws.${data.aws_region.current.name}.s3"
}
