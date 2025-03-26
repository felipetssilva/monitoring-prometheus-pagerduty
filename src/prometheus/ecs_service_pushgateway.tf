locals {
  pushgateway_ecs_task_definition = {
    pushgateway = {
      image_name     = "clouddevops/prometheus_pushgateway"
      image_tag      = "v1.8.0"
      container_port = 9091
      cpu            = var.cpu_pushgateway_service
      memory         = var.memory_pushgateway_service
      additional_security_group_ids = [
        aws_security_group.pushgateway.id
      ]
    }
  }
}