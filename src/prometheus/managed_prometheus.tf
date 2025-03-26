resource "aws_prometheus_workspace" "datahub" {
  alias = "datahub"
  tags  = local.common_tags

  logging_configuration {
    log_group_arn = "${aws_cloudwatch_log_group.amazon_managed_prometheus.arn}:*"
  }
}