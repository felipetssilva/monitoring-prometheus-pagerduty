module "networkdata" {
  source      = "git::ssh://git@gitlab.eulerhermes.io/cloud-devops/terraform-modules/networkdata.git?ref=v2.0.3"
  environment = var.cf_environment

  resources = ["nat2"]
}

module "securitydata" {
  source      = "git::ssh://git@gitlab.eulerhermes.io/cloud-devops/terraform-modules/securitydata.git?ref=v5.1.0"
  environment = var.cf_environment

  resources = {
    kms = null
  }

  providers = {
    aws         = aws
    aws.useast1 = aws.useast1
  }
}

module "securitydata_dr" {
  source      = "git::ssh://git@gitlab.eulerhermes.io/cloud-devops/terraform-modules/securitydata.git?ref=v5.1.0"
  environment = "${var.cf_environment}_dr"

  resources = {
    kms = null
  }

  providers = {
    aws         = aws
    aws.useast1 = aws.useast1
  }
}


module "datahub_shared_infra_main" {
  source = "git::ssh://git@gitlab.eulerhermes.io/deployment/datahub/terraform-modules/shared-output.git//import?ref=v1.2.2"

  environment = var.cf_environment
  project     = "datahub-shared-infra-main"
}
