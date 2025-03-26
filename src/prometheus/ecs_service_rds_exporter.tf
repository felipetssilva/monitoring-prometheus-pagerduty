locals {
  rds_exporter_ecs_task_definition = {
    rds-exporter = {
      image_name     = "datahub/prometheus-rds-exporter"
      image_tag      = "0.10.1"
      container_port = 9043
      cpu            = var.cpu_rds_exporter_service
      memory         = var.memory_rds_exporter_service
      additional_security_group_ids = [
        module.networkdata.allow_nat2_sg_id,
      ]
      environment = [
        {
          name  = "EXTERNAL_URL"
          value = "https://${var.product_name}-rds-exporter.${module.networkdata.domain_zone_name}"
        },
        {
          name  = "PROMETHEUS_RDS_EXPORTER_COLLECT_USAGES"
          value = false
        },
        {
          name  = "PROMETHEUS_RDS_EXPORTER_COLLECT_INSTANCE_METRICS"
          value = false
        },

      ],
      task_role_arn = aws_iam_role.rds_exporter.arn
    }
  }
}

resource "aws_iam_role" "rds_exporter" {
  name               = "role-${local.base_resource_name}-rds-exporter"
  assume_role_policy = data.aws_iam_policy_document.prometheus-rds-exporter-relationship.json
  tags               = local.common_tags
}

data "aws_iam_policy_document" "prometheus-rds-exporter-relationship" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "prometheus-rds-exporter" {
  name   = "policy-${local.base_resource_name}-ecs-task-rds-exporter"
  role   = aws_iam_role.rds_exporter.name
  policy = data.aws_iam_policy_document.prometheus-rds-exporter.json
}

data "aws_iam_policy_document" "prometheus-rds-exporter" {
  #checkov:skip=CKV_AWS_356:checkcov return false positive results (e.g. rds:DescribePendingMaintenanceActions could not have resource limit)

  statement {
    sid    = "AllowInstanceAndLogDescriptions"
    effect = "Allow"
    actions = [
      "rds:DescribeDBInstances",
      "rds:DescribeDBLogFiles",
    ]
    resources = [
      "arn:aws:rds:*:*:db:*",
    ]
  }

  statement {
    sid    = "AllowMaintenanceDescriptions"
    effect = "Allow"
    actions = [
      "rds:DescribePendingMaintenanceActions",
    ]
    resources = ["*"]
  }

  statement {
    sid    = "AllowGettingCloudWatchMetrics"
    effect = "Allow"
    actions = [
      "cloudwatch:GetMetricData",
    ]
    resources = ["*"]
  }

  statement {
    sid    = "AllowRDSUsageDescriptions"
    effect = "Allow"
    actions = [
      "rds:DescribeAccountAttributes",
    ]
    resources = ["*"]
  }

  statement {
    sid    = "AllowQuotaDescriptions"
    effect = "Allow"
    actions = [
      "servicequotas:GetServiceQuota",
    ]
    resources = ["*"]
  }

  statement {
    sid    = "AllowInstanceTypesDescriptions"
    effect = "Allow"
    actions = [
      "ec2:DescribeInstanceTypes",
    ]
    resources = ["*"]
  }
}
