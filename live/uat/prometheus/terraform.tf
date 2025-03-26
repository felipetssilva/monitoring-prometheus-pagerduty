terraform {
  required_version = ">= 1.2"
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "~> 5.0"
      configuration_aliases = [aws.dr]
    }
  }
  backend "s3" {
    bucket         = "yxdzlwvolxmz-uat-datahub-tfstates"
    key            = "uat/datahub/monitoring/default.tfstate"
    dynamodb_table = "yxdzlwvolxmz-uat-tfstates-locks"
    region         = "eu-central-1"
  }
}

provider "aws" {
  region = "eu-central-1"
}

provider "aws" {
  alias  = "useast1"
  region = "us-east-1"
}

provider "aws" {
  region = "eu-west-1"
  alias  = "dr"
}