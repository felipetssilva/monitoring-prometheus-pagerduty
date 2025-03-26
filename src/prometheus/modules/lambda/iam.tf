resource "aws_iam_role" "lambda_role" {
  count              = var.provided_role ? 0 : 1
  name               = format(local.resource_name_pattern, "role")
  assume_role_policy = data.aws_iam_policy_document.lambda_trust_policy.json
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "lambda_role_policy_attachement" {
  count = (var.role_policy_count + 1) * (var.provided_role ? 0 : 1)

  role       = aws_iam_role.lambda_role[0].id
  policy_arn = local.full_role_policy_arns[count.index]
}

data "aws_iam_policy_document" "lambda_trust_policy" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}
