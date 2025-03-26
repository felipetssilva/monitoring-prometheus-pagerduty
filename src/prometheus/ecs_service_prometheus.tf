locals {
  prometheus_ecs_task_definition = {
    prometheus = {
      image_name            = "datahub/monitoring/prometheus"
      image_tag             = "dev"
      container_port        = 9090
      cpu                   = var.cpu_prometheus_service
      memory                = var.memory_prometheus_service
      health_check_endpoint = "/-/healthy"
      volumes = {
        prometheus-config = {
          container_path     = "/prometheus-config"
          efs_root_directory = "/prometheus"
        }
      }
      additional_security_group_ids = [
        module.networkdata.allow_nat2_sg_id,
      ]
      environment = [
        {
          name  = "EXTERNAL_URL"
          value = "https://${var.product_name}-prometheus.${module.networkdata.domain_zone_name}"
        },
      ],
      task_role_arn = aws_iam_role.prometheus.arn
    }
  }
}