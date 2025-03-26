resource "aws_security_group" "pushgateway" {
  name        = "sgr-${local.base_resource_name}-garbage-collection"
  description = "SG allowing inbound for pushgateway_garbage_collector"
  vpc_id      = module.networkdata.vpc_id

  tags = merge(
    { "Name" = "sgr-${local.base_resource_name}-garbage-collection" },
    local.common_tags
  )
}

resource "aws_security_group_rule" "pushgateway_allow_pushgateway_gc" {
  type        = "ingress"
  from_port   = local.services["pushgateway"].container_port
  to_port     = local.services["pushgateway"].container_port
  protocol    = "all"
  description = "Allow inbound traffic for pushgateway_gc"

  security_group_id        = aws_security_group.pushgateway.id
  source_security_group_id = aws_security_group.pushgateway_gc.id
}

resource "aws_security_group" "lambda_config_reloaders" {
  for_each = local.config_reloaders

  name        = "sgr-${local.base_resource_name}-lbd-${each.key}"
  description = "Security Group for the lambda ${local.base_resource_name} that manages the ${each.key} configuration"
  vpc_id      = module.networkdata.vpc_id

  tags = merge(
    {
      Name = "sgr-lbd-${local.base_resource_name}-prometheus"
    },
    local.common_tags
  )
}

resource "aws_security_group_rule" "all_egress_lambda_config_reloaders" {
  for_each = local.config_reloaders

  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "TCP"
  security_group_id = aws_security_group.lambda_config_reloaders[each.key].id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group" "access_to_efs" {
  name        = "sgr-${local.base_resource_name}-services"
  description = "EFS security group to allows NFS traffic from and to efs"
  vpc_id      = module.networkdata.vpc_id

  tags = merge(
    {
      Name = "sgr-${local.base_resource_name}-services"
    },
    local.common_tags,
  )
}

resource "aws_security_group_rule" "inbound_to_efs" {
  for_each                 = local.services_with_volumes
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "TCP"
  security_group_id        = module.efs_cf[each.key].security_group_id
  source_security_group_id = aws_security_group.access_to_efs.id
}

resource "aws_security_group_rule" "inbound_to_ecs" {
  for_each                 = local.services_with_volumes
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "TCP"
  security_group_id        = aws_security_group.access_to_efs.id
  source_security_group_id = module.efs_cf[each.key].security_group_id
}

resource "aws_security_group_rule" "outbound_from_efs" {
  for_each                 = local.services_with_volumes
  type                     = "egress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "TCP"
  security_group_id        = module.efs_cf[each.key].security_group_id
  source_security_group_id = aws_security_group.access_to_efs.id
}

resource "aws_security_group_rule" "outbound_to_efs" {
  for_each                 = local.services_with_volumes
  type                     = "egress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "TCP"
  security_group_id        = aws_security_group.access_to_efs.id
  source_security_group_id = module.efs_cf[each.key].security_group_id
}

resource "aws_security_group" "alertmanager" {
  name        = "sgr-${local.base_resource_name}-alertmanager-cluster"
  description = "Used by alertmanager to communicate with each other members of the alertmanager cluster"
  vpc_id      = module.networkdata.vpc_id

  tags = merge({
    Name = "sgr-${local.base_resource_name}-cluster"
  }, local.common_tags)
}


resource "aws_security_group_rule" "alertmanagers" {
  for_each = toset(local.protocols)

  description       = "Allow all other alertmanager Traffic for ECS"
  security_group_id = aws_security_group.alertmanager.id
  type              = "ingress"
  protocol          = each.key

  from_port = local.alertmanagers["alertmanager"].cluster_port
  to_port   = local.alertmanagers["alertmanager2"].cluster_port

  source_security_group_id = aws_security_group.alertmanager.id
}
