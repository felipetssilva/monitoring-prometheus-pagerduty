##############################################################
#
# Lambda Function
#
##############################################################
resource "aws_lambda_function" "lambda" {
  depends_on = [aws_cloudwatch_log_group.lambda_cloudwatch_log_group]

  architectures     = var.architectures
  s3_bucket         = var.s3_bucket
  s3_key            = var.s3_key
  s3_object_version = var.s3_object_version
  function_name     = format(local.resource_name_pattern, "lbd")
  role = var.provided_role ? var.role_arn : element(concat(aws_iam_role.lambda_role[*].arn, [
    ""
  ]), 0)
  handler                        = var.handler
  runtime                        = var.runtime
  memory_size                    = var.memory
  timeout                        = var.timeout
  reserved_concurrent_executions = var.concurrency
  description                    = var.description
  kms_key_arn                    = var.kms_key_arn
  tags                           = var.tags
  publish                        = var.publish
  layers = var.short_description == "prometheus" ? [
    aws_lambda_layer_version.promtool.arn
  ] : []
  image_uri    = var.image_uri
  package_type = var.package_type

  ephemeral_storage {
    size = var.ephemeral_storage # Min 512 MB and the Max 10240 MB
  }

  dynamic "image_config" {
    for_each = length(var.docker_cmd) > 0 || length(var.docker_entrypoint) > 0 || var.docker_working_directory != null ? [
      true
    ] : []
    content {
      command           = var.docker_cmd
      entry_point       = var.docker_entrypoint
      working_directory = var.docker_working_directory
    }
  }

  tracing_config {
    mode = var.tracing_config
  }

  dynamic "vpc_config" {
    for_each = length(var.vpc_subnet_ids) > 0 ? [local.final_security_group_ids] : []
    content {
      subnet_ids         = var.vpc_subnet_ids
      security_group_ids = local.final_security_group_ids
    }
  }

  dynamic "file_system_config" {
    for_each = var.efs_access_point_arn == null ? [] : [var.efs_access_point_arn]
    content {
      arn              = var.efs_access_point_arn
      local_mount_path = "/mnt/efs"
    }
  }

  dynamic "environment" {
    for_each = length(keys(var.env)) == 0 ? [] : [var.env]

    content {
      variables = var.env
    }
  }

  dynamic "dead_letter_config" {
    for_each = compact([var.dead_letter_config_arn])

    content {
      target_arn = var.dead_letter_config_arn
    }
  }
  dynamic "snap_start" {
    for_each = var.runtime == "java11" && var.enable_snapstart ? toset(["snap"]) : []

    content {
      apply_on = "PublishedVersions"
    }
  }

  lifecycle {
    replace_triggered_by = [
      aws_lambda_layer_version.promtool
    ]
  }
}

##############################################################
#
# Lambda Alias
#
##############################################################

resource "aws_lambda_alias" "lambda_alias" {
  count = var.publish ? 1 : 0

  function_name    = aws_lambda_function.lambda.function_name
  function_version = var.lambda_alias_function_version != null ? var.lambda_alias_function_version : aws_lambda_function.lambda.version
  name             = var.lambda_alias
}

##############################################################
#
# Lambda permissions
#
##############################################################

resource "aws_lambda_permission" "lambda_permission" {
  count = length(var.source_services)

  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name

  principal      = "${var.source_services[count.index]}.amazonaws.com"
  source_arn     = var.source_arns[count.index]
  source_account = var.source_services[count.index] == "s3" ? var.account_id : null
}

##############################################################
#
# Lambda provisioned capacity
#
##############################################################

resource "aws_lambda_provisioned_concurrency_config" "provisioned_concurrency" {
  count = (var.provisioned_concurrency > 10 || var.provisioned_concurrency < 1) ? 0 : 1

  function_name                     = aws_lambda_function.lambda.function_name
  provisioned_concurrent_executions = var.provisioned_concurrency
  qualifier                         = aws_lambda_function.lambda.version
}

##############################################################
#
# Lambda layer - CUSTOM DATAHUB
#
##############################################################

resource "aws_lambda_layer_version" "promtool" {
  layer_name          = "lbl-${var.environment}-${var.product_name}-promtool"
  filename            = "${path.root}/artifacts/prometheus_config_reloader-promtool-${var.environment}.zip"
  compatible_runtimes = ["python3.9", "python3.10"]
  source_code_hash    = filebase64sha256("${path.root}/artifacts/prometheus_config_reloader-promtool-${var.environment}.zip")
}
