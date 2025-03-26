terraform {
  required_version = ">= 1.2"
  required_providers {
    pagerduty = {
      source  = "pagerduty/pagerduty"
      version = ">= 3.15.6"
    }
  }
  backend "s3" {
    bucket         = "yxdzlwvolxmz-prod-datahub-tfstates"
    key            = "dev/datahub/monitoring/pagerduty.tfstate"
    dynamodb_table = "yxdzlwvolxmz-prod-tfstates-locks"
    region         = "eu-central-1"
  }
}

provider "pagerduty" {
}

provider "aws" {

}
