module "cluster" {
  source = "git::ssh://git@gitlab.eulerhermes.io/deployment/datahub/terraform-modules/ecs-cluster.git?ref=v3.1.1"

  costcenter     = var.costcenter
  cf_environment = var.cf_environment
  environment    = var.environment
  owner          = var.owner
  product_name   = var.product_name

  main_certificate_arn = module.certificate.arn

  providers = {
    aws.useast1 = aws.useast1
  }
}