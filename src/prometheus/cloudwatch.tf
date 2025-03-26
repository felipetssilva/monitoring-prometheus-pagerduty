resource "aws_cloudwatch_log_group" "amazon_managed_prometheus" {
  name              = "clg-${var.environment}-datahub-amazon_managed_prometheus_logs"
  retention_in_days = 90
  tags              = local.common_tags
}