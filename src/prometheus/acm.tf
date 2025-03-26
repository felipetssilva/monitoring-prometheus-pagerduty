module "certificate" {
  source = "git::ssh://git@gitlab.eulerhermes.io/deployment/datahub/terraform-modules/certificate.git?ref=v3.0.0"

  costcenter     = var.costcenter
  cf_environment = var.cf_environment
  environment    = var.environment
  owner          = var.owner
  product_name   = var.product_name

  # TODO: Change this from "${var.product_name}-test" to
  # "${var.product_name}" when we are ready to use this
  # monitoring stack as our main monitoring task
  subdomain = "${var.product_name}-test"
}