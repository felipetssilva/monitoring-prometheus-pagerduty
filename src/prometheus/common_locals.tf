locals {
  common_tags = {
    Environment = var.environment
    CostCenter  = var.costcenter
    Owner       = var.owner
    Application = var.product_name
  }

  base_resource_name = "${var.environment}-${var.product_name}"
  ecr_repository_id  = 316857779566
  ecr_repository_url = "${local.ecr_repository_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com"
}

data "aws_region" "current" {}

data "aws_region" "dr" {
  provider = aws.dr
}

data "aws_caller_identity" "current" {}
