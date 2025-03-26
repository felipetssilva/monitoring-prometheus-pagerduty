module "alb" {
  source = "git::ssh://git@gitlab.eulerhermes.io/cloud-devops/terraform-modules/alb.git//simple_alb?ref=v4.0.1"

  environment          = var.environment
  product_name         = var.product_name
  vpc_id               = module.networkdata.vpc_id
  subnets              = module.networkdata.private_subnet_ids
  access_log_bucket_id = module.access_logs.bucket_id
  main_certificate_arn = module.certificate.arn
  principal_tags       = local.common_tags
}

module "access_logs" {
  source = "git::ssh://git@gitlab.eulerhermes.io/cloud-devops/terraform-modules/alb_nlb_access_logs_bucket.git?ref=v6.0.0"

  account_name      = var.cf_environment
  environment       = var.environment
  product_name      = var.product_name
  short_description = "access_logs"
  send_to_splunk    = false
  principal_tags    = local.common_tags
  sqs_queue_arn     = module.securitydata.sqs_queue_arn

  providers = {
    aws         = aws
    aws.dr      = aws.dr
    aws.general = aws.useast1
  }
}
