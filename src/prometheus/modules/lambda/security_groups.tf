data "aws_security_group" "default" {
  count = var.attach_managed_sg == true ? 1 : 0
  name  = length(var.managed_sg_environment) > 0 ? "sgr-${var.managed_sg_environment}-default-lambda-sgr" : "sgr-${var.environment}-default-lambda-sgr"
}
