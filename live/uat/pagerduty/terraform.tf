terraform {
  required_version = ">= 1.2"
  required_providers {
    pagerduty = {
      source  = "pagerduty/pagerduty"
      version = ">= 3.15.6"
    }
  }
  backend "s3" {
    bucket         = "yxdzlwvolxmz-uat-datahub-tfstates"
    key            = "uat/datahub/monitoring/pagerduty.tfstate"
    dynamodb_table = "yxdzlwvolxmz-uat-tfstates-locks"
    region         = "eu-central-1"
  }
}
