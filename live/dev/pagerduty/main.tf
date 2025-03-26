module "pagerduty" {
  source = "../../../src/pagerduty"

  environment = "dev"
  channel_ids = {
    datahub = "C07UT209H28" #dev-datahub-incident
    dataviz = "C07USQ56YCC" #datahub-dataviz-incident
  }
}
