resource "aws_iam_role" "snowflake" {
  name               = "role-${local.base_resource_name}-prometheus-snowflake"
  assume_role_policy = var.iam_role_assume_role_policy

  tags = local.common_tags
}

data "aws_iam_policy_document" "snowflake" {
  statement {
    effect    = "Allow"
    actions   = ["kms:Decrypt", "kms:GenerateDataKey"]
    resources = [var.kms_key_arn]
  }

  dynamic "statement" {
    for_each = var.snowflake_environments
    content {
      effect  = "Allow"
      actions = ["ssm:GetParameter"]
      # TODO: Change this ARN to be based on export (SSM) instead of constructing it
      resources = ["arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/${statement.value}/datahub/snowflake/password/snwu_${statement.value}_monitor"]
    }
  }
}

resource "aws_iam_policy" "snowflake" {
  name_prefix = "policy-${local.base_resource_name}-prometheus-snowflake"
  policy      = data.aws_iam_policy_document.snowflake.json

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "snowflake" {
  role       = aws_iam_role.snowflake.name
  policy_arn = aws_iam_policy.snowflake.arn
}