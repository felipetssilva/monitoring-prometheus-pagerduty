locals {
  alertmanagers = {
    for i in range(3) :
    "alertmanager${i != 0 ? i : ""}" => {
      image_name     = "datahub/prometheus_alertmanager"
      image_tag      = var.environment
      cpu            = 256
      memory         = 512
      container_port = 9000 + i
      cluster_port   = 8000 + i
      environment = [
        {
          name  = "LOG_LEVEL"
          value = "info"
        }
      ]
    }
  }
  unencrypted_pagerduty_routing_keys = {
    for routing_key in keys(var.encrypted_pagerduty_routing_keys) :
    routing_key => data.aws_kms_secrets.unencrypted_pagerduty_routing_keys[0].plaintext[routing_key]
  }
  # NOTE: Alertmanager uses UDP and TCP for its HA protocol, as it uses Hashicorp
  # Memerblist lib in the backend to setup gossip between Alertmanagers instances
  protocols = [
    "udp",
    "tcp"
  ]
}

module "alertmanagers" {
  for_each = local.alertmanagers
  source   = "git::ssh://git@gitlab.eulerhermes.io/deployment/datahub/terraform-modules/ecs-service.git?ref=v4.0.1"

  cf_environment = var.cf_environment
  costcenter     = var.costcenter
  environment    = var.environment
  owner          = var.owner
  product_name   = var.product_name

  # host cluster configuration
  cluster_name                       = module.cluster.cluster_name
  cluster_id                         = module.cluster.cluster_id
  cluster_lb_security_group_id       = module.alb.security_group_id
  cluster_load_balancer_arn          = module.alb.arn
  cluster_load_balancer_hostname     = module.alb.dns_name
  cluster_load_balancer_zone_id      = module.alb.zone_id
  task_execution_role_arn            = module.cluster.task_execution_role.arn
  cluster_load_balancer_listener_arn = module.alb.listener_arn

  # tasks configuration
  ## Basic
  service_name      = each.key
  image_name        = each.value.image_name
  image_tag         = each.value.image_tag
  ecr_repository_id = local.ecr_repository_id
  cpu               = each.value.cpu
  memory            = each.value.memory

  ## Log
  log_retention_days = var.log_retention_days

  ## Networking
  container_port                = each.value.container_port
  additional_security_group_ids = [aws_security_group.alertmanager.id, module.networkdata.allow_nat2_sg_id]
  health_check_endpoint         = try(each.value["health_check_endpoint"], "/-/healthy")
  # NOTE: See "High Availability in Alertmanager" part in documentation
  # to understand how Alertmanager HA works in our code.
  container_environment_variables = concat(
    each.value.environment,
    [
      {
        name  = "CLUSTER_PORT"
        value = tostring(each.value.cluster_port)
      },
      {
        name  = "ALERTMANAGER_PORT"
        value = tostring(each.value.container_port)
      },
      #FIXME: See if we can get fetch value dynamicaly instead
      {
        name  = "EXTERNAL_URL"
        value = "https://${var.product_name}-${each.key}.${module.networkdata.domain_zone_name}"
      },
    ],
    # NOTE: each.key != "alertmanager" means that the current alertmanager is not a
    # "master" node so we need to add INITIAL_CLUSTER_PEER env var to its configuration
    each.key != "alertmanager" ? [
      {
        name  = "INITIAL_CLUSTER_PEER"
        value = "${var.environment}-${var.product_name}-alertmanager.${var.environment}.discovery.aws.intra.net:${local.alertmanagers["alertmanager"].cluster_port}"
      },
    ] : []
  )

  secrets = [
    # Pager duty routing keys from SSM
    for key_name in keys(var.encrypted_pagerduty_routing_keys) :
    {
      name      = key_name
      valueFrom = var.environment == "prod" ? data.aws_ssm_parameter.encrypted_pagerduty_routing_keys[key_name].arn : aws_ssm_parameter.encrypted_pagerduty_routing_keys[key_name].arn
      # FIXME: Delete after migration
      #valueFrom = aws_ssm_parameter.encrypted_pagerduty_routing_keys[key_name].arn # FIXME: Uncomment after migration
    }
  ]

  ## Storage
  # NOTE: Alertmanager share alerts and silences (by gossiping) so we do not need volumes.
  volumes = {}

  providers = {
    aws.useast1 = aws.useast1
  }
}