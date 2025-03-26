locals {
  services = merge(
    local.blackbox_ecs_task_definition,
    local.cloudwatch_exporter_ecs_task_definition,
    local.snowflake_ecs_task_definition,
    local.prometheus_ecs_task_definition,
    local.pushgateway_ecs_task_definition,
    local.rds_exporter_ecs_task_definition
  )
  services_with_volumes = toset([
    for svc_name, svc in local.services : svc_name if can(svc.volumes)
  ])
}

module "services" {
  for_each       = local.services
  source         = "git::ssh://git@gitlab.eulerhermes.io/deployment/datahub/terraform-modules/ecs-service.git?ref=v4.0.1"
  cf_environment = var.cf_environment
  costcenter     = var.costcenter
  environment    = var.environment
  owner          = var.owner
  product_name   = var.product_name

  container_command = try(each.value.command, null)

  # host cluster configuration
  cluster_name                       = module.cluster.cluster_name
  cluster_id                         = module.cluster.cluster_id
  cluster_lb_security_group_id       = module.alb.security_group_id
  cluster_load_balancer_arn          = module.alb.arn
  cluster_load_balancer_hostname     = module.alb.dns_name
  cluster_load_balancer_zone_id      = module.alb.zone_id
  cluster_load_balancer_listener_arn = module.alb.listener_arn
  task_execution_role_arn            = module.cluster.task_execution_role.arn

  # tasks configuration
  ## Basic
  service_name                    = each.key
  image_name                      = each.value.image_name
  image_tag                       = each.value.image_tag
  ecr_repository_id               = local.ecr_repository_id
  cpu                             = each.value["cpu"]
  memory                          = each.value["memory"]
  container_environment_variables = try(each.value["environment"], [])
  task_role_arn                   = try(each.value["task_role_arn"], null)
  platform_version                = "1.4.0"

  ## Log
  log_retention_days = var.log_retention_days

  ## Networking
  container_port                = each.value["container_port"]
  additional_security_group_ids = try(each.value["additional_security_group_ids"], [])
  health_check_endpoint         = try(each.value["health_check_endpoint"], "/-/healthy")

  ## Storage
  volumes               = try(each.value["volumes"], {})
  efs_security_group_id = try(module.efs_cf[each.key], null) == null ? null : aws_security_group.access_to_efs.id
  efs_id                = try(module.efs_cf[each.key], null) == null ? null : module.efs_cf[each.key].id

  providers = {
    aws.useast1 = aws.useast1
  }
}
