terraform {
  required_version = ">= 1.1"
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "~> 5.0"
      configuration_aliases = [aws.dr, aws.useast1]
    }
  }
}