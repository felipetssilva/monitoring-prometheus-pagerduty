module "efs_cf" {
  for_each = local.services_with_volumes
  source   = "git::ssh://git@gitlab.eulerhermes.io/cloud-devops/terraform-modules/efs.git?ref=v3.0.1"

  application  = var.product_name
  costcenter   = var.costcenter
  environment  = var.environment
  owner        = var.owner
  product_name = each.key

  # Set to true only for critical business app.
  # Other stack handle backups on their own.
  to_backup = false

  vpc_id  = module.networkdata.vpc_id
  subnets = module.networkdata.private_subnet_ids

  kms_key_id = module.securitydata.ebs_key_target_key_arn

  access_points = {
    "${each.key}" = {
      posix_user = {
        uid = 1000
        gid = 1000
      }
      creation_info = {
        permissions = 777
        uid         = 1000
        gid         = 1000
      }
    }
  }
}


