resource "aws_security_group" "ecs_snowflake_exporter" {
  name        = "sgr-${local.base_resource_name}-snowflake-exporter"
  description = "Security Group for ECS service snowflake exporter to contact snowflake"
  vpc_id      = var.vpc_id

  tags = merge(
    {
      "Name" = "sgr-${local.base_resource_name}"
    },
    local.common_tags
  )
}

resource "aws_security_group_rule" "snowflake_egress_443" {
  type      = "egress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"
  cidr_blocks = distinct(flatten([
    module.networkdata.private_subnet_cidr,
    module.networkdata.database_subnet_cidr,
    data.aws_prefix_list.prefix_list_s3.cidr_blocks,
    [module.networkdata.networking_outputs.vpc_cidr, module.networkdata.shared_private_subnet_cidrs]
  ]))
  security_group_id = aws_security_group.ecs_snowflake_exporter.id
}

resource "aws_security_group_rule" "snowflake_egress_80" {
  type      = "egress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"
  cidr_blocks = distinct(flatten([
    module.networkdata.private_subnet_cidr,
    module.networkdata.database_subnet_cidr,
    data.aws_prefix_list.prefix_list_s3.cidr_blocks,
    [module.networkdata.networking_outputs.vpc_cidr, module.networkdata.shared_private_subnet_cidrs]
  ]))
  security_group_id = aws_security_group.ecs_snowflake_exporter.id
}

resource "aws_security_group_rule" "snowflake_security_group_rule_http_https" {
  for_each                 = toset(["80", "443"])
  description              = "Accept ingress from snowflake export on port ${each.value}"
  type                     = "ingress"
  from_port                = each.value
  to_port                  = each.value
  protocol                 = "TCP"
  source_security_group_id = aws_security_group.ecs_snowflake_exporter.id
  security_group_id        = module.snowflake_privatelink[0].data.snowflake_vpc_endpoint_sg_id
}
