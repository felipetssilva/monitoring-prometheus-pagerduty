locals {
  cloudwatch_exporter_ecs_task_definition = {
    cloudwatch = {
      image_name     = "datahub/prometheus_cloudwatch_exporter"
      image_tag      = var.environment
      container_port = 9106
      cpu            = var.cpu_cloudwatch_service
      memory         = var.memory_cloudwatch_service
      task_role_arn  = aws_iam_role.cloudwatch.arn
      environment = [
        {
          name  = "SENTRY_DSN"
          value = "https://d0a59d866ec6410c9582fa7b734ee02b@sentry.infra.eulerhermes.io/58"
        },
        {
          name  = "SENTRY_ENVIRONMENT"
          value = var.environment
        },
        {
          name  = "AWS_DEFAULT_REGION"
          value = data.aws_region.current.name
        },
        {
          name  = "AWS_ROLE_ARN"
          value = aws_iam_role.cloudwatch.arn
        }
      ]
      additional_security_group_ids = [
        module.networkdata.allow_nat2_sg_id
      ]
      volumes = {
        prometheus-config = {
          container_path     = "/config"
          efs_root_directory = "/"
        }
      }
    }
  }
}