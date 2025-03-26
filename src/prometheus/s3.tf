module "prometheus_infra_bucket" {
  source = "git::ssh://git@gitlab.eulerhermes.io/cloud-devops/terraform-modules/s3_bucket?ref=v5.2.0"

  bucket       = "new-prometheus"
  environment  = var.environment
  product      = var.product_name
  tags         = local.common_tags
  to_backup    = false
  to_replicate = true

  bucket_encryption_key_id = module.securitydata.s3_key_target_key_arn
}