resource "aws_cloudwatch_log_group" "lambda_cloudwatch_log_group" {
  name              = "/aws/lambda/${format(local.resource_name_pattern, "lbd")}"
  retention_in_days = var.cloudwatch_retention_days

  tags = merge(
    {
      "Description" = format("%s", var.cloudwatch_log_group_description)
    },
    var.tags,
  )
}

