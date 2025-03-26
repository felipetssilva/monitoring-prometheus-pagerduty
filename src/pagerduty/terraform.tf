terraform {
  required_version = ">= 1.2"
  required_providers {
    pagerduty = {
      source  = "pagerduty/pagerduty"
      version = ">= 3.15.6"
    }
  }
}
