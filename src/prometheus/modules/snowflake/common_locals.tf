locals {
  common_tags = {
    Environment = var.environment
    CostCenter  = var.costcenter
    Owner       = var.owner
    # NOTE: Since new CI User Account, Application Tag must contains team name
    # See https://confluence.eulerhermes.com/pages/viewpage.action?spaceKey=ICD&title=Owner+Tag
    Application = var.product_name
  }

  base_resource_name = "${var.environment}-${var.product_name}-${var.service_name}"

}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}