module "aws_backup" {
  source = "git::ssh://git@gitlab.eulerhermes.io/cloud-devops/terraform-modules/aws_backup.git?ref=v5.0.0"

  kms_key_arn       = module.securitydata.ebs_key_target_key_arn
  app_sn            = var.product_name
  short_description = "new"
  # Weird value used to mention this is the new monitoring stack. See aws_backup_plan naming pattern inside module definition for more info.
  environment = var.cf_environment
  costcenter  = var.costcenter
  owner       = var.owner

  enable_continuous_backup = true

  backup_rules = [
    {
      "cron_schedule"                     = "cron(00 0/12 * * ? *)"
      "start_window"                      = "60"
      "completion_window"                 = "120"
      "lifecycle_cold_storage_after_days" = "0"
      "lifecycle_delete_after_days"       = "7"
    }
  ]

  recovery_point_tags = {
    Name        = "backup-${var.product_name}"
    Type        = "efs"
    Description = "Datahub new monitoring stack backups"
  }

  resource_type_list = [for efs in module.efs_cf : efs.arn]

  providers = {
    aws.dr_region     = aws.dr
    aws.cross_account = aws
  }

  cross_account_copy = {
    enable                            = var.environment == "prod"
    region                            = data.aws_region.current.name
    destination_kms_key_arn           = module.securitydata.backup_key_target_key_arn
    lifecycle_cold_storage_after_days = 0
    lifecycle_delete_after_days       = 35
  }

  cross_region_copy = {
    enable                            = contains(["prod"], var.environment)
    region                            = data.aws_region.dr.name
    kms_key_arn                       = module.securitydata_dr.rds_key_target_key_arn
    lifecycle_cold_storage_after_days = 0
    lifecycle_delete_after_days       = 7
  }

  vault_lock_configuration_ca = {
    enable              = var.environment == "prod"
    changeable_for_days = 7
    min_retention_days  = 4
    max_retention_days  = 35
  }

  vault_lock_configuration_dr = {
    enable              = contains(["prod"], var.environment)
    changeable_for_days = 3
    min_retention_days  = 4
    max_retention_days  = 35
  }

  vault_lock_configuration = {
    enable              = true
    changeable_for_days = 7
    min_retention_days  = 4
    max_retention_days  = 35
  }
}