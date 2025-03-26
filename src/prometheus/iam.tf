resource "aws_iam_role" "cloudwatch" {
  name_prefix        = "role-${local.base_resource_name}-cwatch"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json

  tags = local.common_tags
}

data "aws_iam_policy_document" "cloudwatch" {
  statement {
    actions = [
      "cloudwatch:ListMetrics",
      "cloudwatch:GetMetricStatistics",
      "tag:GetResources"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "cloudwatch" {
  name_prefix = "policy-${local.base_resource_name}-ecs-task-cloudwatch"
  policy      = data.aws_iam_policy_document.cloudwatch.json

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "cloudwatch" {
  role       = aws_iam_role.cloudwatch.name
  policy_arn = aws_iam_policy.cloudwatch.arn
}

data "aws_iam_policy_document" "ecs_task_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "ssm" {
  name        = "policy-${local.base_resource_name}-ssm"
  description = "Policy to allow ${var.product_name} ECS Cluster to access SSM"
  policy      = data.aws_iam_policy_document.ssm.json
  tags        = local.common_tags
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = module.cluster.task_execution_role.name
  policy_arn = aws_iam_policy.ssm.arn
}

data "aws_iam_policy_document" "ssm" {
  dynamic "statement" {
    for_each = try([keys(var.encrypted_pagerduty_routing_keys)[0]], [])
    content {
      actions = [
        "ssm:GetParameters",
        "secretsmanager:GetSecretValue"
      ]
      # FIXME : We bypass ssm creation on prod and get values instead.
      # After migration, we should revert
      resources = var.environment == "prod" ? values(data.aws_ssm_parameter.encrypted_pagerduty_routing_keys).*.arn : values(aws_ssm_parameter.encrypted_pagerduty_routing_keys).*.arn
      #resources = values(aws_ssm_parameter.encrypted_pagerduty_routing_keys).*.arn # PagerDuty routing keys for Alertmanager
    }
  }

  # Allowing using KMS with "s3_key_target_key_arn" key of security data module
  statement {
    actions = [
      "kms:Decrypt"
    ]
    resources = [
      module.securitydata.s3_key_target_key_arn # KMS key used for encrypting pagerduty routing keys
    ]
  }
}

data "aws_iam_policy_document" "s3_kms" {
  statement {
    actions = [
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:GenerateDataKey",
    ]
    resources = [
      module.securitydata.s3_key_target_key_arn,
    ]
  }
}

resource "aws_iam_policy" "s3_kms" {
  name        = "policy-${local.base_resource_name}-allow-s3-kms"
  description = "Policy to access kms on the security 02 account"
  policy      = data.aws_iam_policy_document.s3_kms.json

  tags = local.common_tags
}

### PROM task role allowing AMP write
data "aws_iam_policy_document" "prom_amp_write" {
  statement {
    actions = [
      "aps:RemoteWrite"
    ]
    resources = [aws_prometheus_workspace.datahub.arn]
  }
}

resource "aws_iam_role" "prometheus" {
  name_prefix        = "role-${local.base_resource_name}-prom"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json

  tags = local.common_tags
}

resource "aws_iam_policy" "prometheus" {
  name        = "policy-${local.base_resource_name}-prom"
  description = "Policy to allow writing on prometheus managed service"
  policy      = data.aws_iam_policy_document.prom_amp_write.json

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "prometheus" {
  role       = aws_iam_role.prometheus.name
  policy_arn = aws_iam_policy.prometheus.arn
}

## Allow Lambda to Read/List s3 Bucket
data "aws_iam_policy_document" "s3_objects" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]
    resources = [
      module.prometheus_infra_bucket.arn,
      join("/", [module.prometheus_infra_bucket.arn, "*"])
    ]
  }
}

resource "aws_iam_policy" "s3_objects" {
  name        = "policy-${local.base_resource_name}-allow-s3"
  description = "Policy to access s3 Objects"
  policy      = data.aws_iam_policy_document.s3_objects.json

  tags = local.common_tags
}