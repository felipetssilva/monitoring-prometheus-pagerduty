locals {
  service_name = "pushgateway_garbage_collector"
  image_tag    = "v1.0.0"
}

#####################
### Security groups
#####################
resource "aws_security_group" "pushgateway_gc" {
  name        = "sgr-${local.base_resource_name}-${local.service_name}"
  description = "SG for ECS pushgateway metrics garbage collection task"
  vpc_id      = module.networkdata.vpc_id


  tags = merge({
    Name = "sgr-${local.base_resource_name}-${local.service_name}"
  }, local.common_tags)
}

resource "aws_security_group_rule" "allow_traffic_to_pushgateway" {
  type      = "egress"
  from_port = local.services["pushgateway"].container_port
  to_port   = local.services["pushgateway"].container_port
  protocol  = "all"

  description = "Allow outbound traffic on pushgateway port"

  security_group_id        = aws_security_group.pushgateway_gc.id
  source_security_group_id = aws_security_group.pushgateway.id
}

#####################
### CloudWatch
#####################
resource "aws_cloudwatch_event_rule" "this" {
  name        = "cer-${local.base_resource_name}-${local.service_name}"
  description = "Garbage collection of outdated metrics pushed to pushgateway"

  # TODO swith to events (e.g. trigger a flush when efs BytesTotal exceeds a threshold)
  schedule_expression = "cron(01 * * * ? *)"

  tags = local.common_tags
}


resource "aws_cloudwatch_event_target" "ecs_scheduled_task" {
  target_id = "${local.base_resource_name}-${local.service_name}"

  rule     = aws_cloudwatch_event_rule.this.name
  role_arn = module.cluster.task_execution_role.arn

  arn = module.cluster.cluster_id

  ecs_target {
    launch_type         = "FARGATE"
    platform_version    = module.services["pushgateway"].platform_version
    task_count          = 1
    task_definition_arn = aws_ecs_task_definition.pushgateway_gc.arn
    tags                = local.common_tags
    propagate_tags      = "TASK_DEFINITION"
    network_configuration {
      security_groups = [
        aws_security_group.pushgateway_gc.id,
      ]
      subnets = module.networkdata.private_subnet_ids
    }
  }
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "clg-${local.base_resource_name}"
  retention_in_days = var.log_retention_days
  tags              = local.common_tags
}

#####################
### ECS
#####################
resource "aws_ecs_task_definition" "pushgateway_gc" {
  family                   = "td-${local.base_resource_name}-${local.service_name}"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  network_mode             = "awsvpc"
  execution_role_arn       = module.cluster.task_execution_role.arn
  tags                     = local.common_tags

  container_definitions = jsonencode([
    {
      name  = local.service_name,
      image = "${local.ecr_repository_url}/clouddevops/prometheus_pushgateway_garbage_collector:${local.image_tag}",
      portMappings = [{
        containerPort = 9091
      }],
      user = "1000:1000"
      environment = [
        { name = "PUSHGATEWAY_HOST", value = module.services["pushgateway"].service_discovery_endpoint },
        { name = "PUSHGATEWAY_PORT", value = tostring(local.services["pushgateway"].container_port) },
        { name = "DEBUG", value = "true" }
      ]
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.this.name,
          "awslogs-region"        = data.aws_region.current.name,
          "awslogs-stream-prefix" = local.service_name
        }
      }
    }
  ])
}
