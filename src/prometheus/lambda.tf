module "lambda_config_reloaders" {
  for_each = local.config_reloaders
  source   = "./modules/lambda"

  environment       = var.environment
  product_name      = var.product_name
  short_description = each.key

  # Basic
  handler     = "prometheus_config_reloader/main.${each.value.handler_name}"
  runtime     = "python3.10"
  description = "Datahub - Lambda used to reload the ${each.key} configuration files."
  memory      = 256
  timeout     = 300

  # Code
  s3_bucket         = aws_s3_object.lambda_config_reloaders.bucket
  s3_key            = aws_s3_object.lambda_config_reloaders.key
  s3_object_version = aws_s3_object.lambda_config_reloaders.version_id

  lambda_alias                  = "version_1"
  lambda_alias_function_version = 1

  # Volume
  efs_access_point_arn = module.efs_cf[each.value.equivalent_ecs_service].access_point_arns[each.value.equivalent_ecs_service]

  env = merge(
    {
      BUCKET_NAME = module.prometheus_infra_bucket.id
    },
    each.value.environment
  )

  # IAM
  role_policy_arns = [
    aws_iam_policy.s3_kms.arn,
    module.efs_cf[each.value.equivalent_ecs_service].policy_arn,
    aws_iam_policy.s3_objects.arn
  ]
  role_policy_count = length([
    # NOTE: We need to provide an explicit count because of terraform issue
    aws_iam_policy.s3_kms.arn,
    module.efs_cf[each.value.equivalent_ecs_service].policy_arn,
    aws_iam_policy.s3_objects.arn
  ])

  # Network
  vpc_subnet_ids = module.networkdata.private_subnet_ids
  security_group_ids = [
    aws_security_group.lambda_config_reloaders[each.key].id,
    aws_security_group.access_to_efs.id,
  ]
  attach_managed_sg = true

  # Cloudwatch
  cloudwatch_retention_days = var.log_retention_days

  tags = local.common_tags
}

resource "aws_lambda_permission" "lambda_config_reloaders" {
  for_each = local.config_reloaders

  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_config_reloaders[each.key].arn
  principal     = "s3.amazonaws.com"
  source_arn    = module.prometheus_infra_bucket.arn
}