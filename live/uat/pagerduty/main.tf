module "pagerduty-uatm" {
  source = "../../../src/pagerduty"

  environment = "uatm"
}

module "pagerduty-uatr" {
  source = "../../../src/pagerduty"

  environment = "uatr"
}
