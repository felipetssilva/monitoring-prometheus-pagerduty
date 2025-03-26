module "monitoring_infrastructure" {
  source = "../../../src/prometheus"

  cf_environment         = local.cf_environment
  environment            = local.environment
  snowflake_environments = local.snowflake_environments
  blackbox_environments  = local.blackbox_environments
  costcenter             = local.costcenter
  owner                  = local.owner
  product_name           = local.product_name
  log_retention_days     = 7

  # Dummy values in dev environnment for testing purpose.
  encrypted_pagerduty_routing_keys = {
    PAGERDUTY_ROUTING_KEY_INTERNALS         = "AQICAHjaUXkOwaFpTGA12n5Ifb6Q0znaDbuU6SyEU0N9fyaf+QFQK5dVUWAVO6PzItHemiCxAAAAajBoBgkqhkiG9w0BBwagWzBZAgEAMFQGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMoI1IQ/I6F8+7mLIEAgEQgCexGzu6/RajcXvGjcoFi0e8XqrDuS9eCDrLvy/lnXm2ILufDelWw2g="
    PAGERDUTY_ROUTING_KEY_KPIF              = "AQICAHjaUXkOwaFpTGA12n5Ifb6Q0znaDbuU6SyEU0N9fyaf+QFQK5dVUWAVO6PzItHemiCxAAAAajBoBgkqhkiG9w0BBwagWzBZAgEAMFQGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMoI1IQ/I6F8+7mLIEAgEQgCexGzu6/RajcXvGjcoFi0e8XqrDuS9eCDrLvy/lnXm2ILufDelWw2g="
    PAGERDUTY_ROUTING_KEY_BE                = "AQICAHjaUXkOwaFpTGA12n5Ifb6Q0znaDbuU6SyEU0N9fyaf+QFQK5dVUWAVO6PzItHemiCxAAAAajBoBgkqhkiG9w0BBwagWzBZAgEAMFQGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMoI1IQ/I6F8+7mLIEAgEQgCexGzu6/RajcXvGjcoFi0e8XqrDuS9eCDrLvy/lnXm2ILufDelWw2g="
    PAGERDUTY_ROUTING_KEY_CORE              = "AQICAHjaUXkOwaFpTGA12n5Ifb6Q0znaDbuU6SyEU0N9fyaf+QFQK5dVUWAVO6PzItHemiCxAAAAajBoBgkqhkiG9w0BBwagWzBZAgEAMFQGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMoI1IQ/I6F8+7mLIEAgEQgCexGzu6/RajcXvGjcoFi0e8XqrDuS9eCDrLvy/lnXm2ILufDelWw2g="
    PAGERDUTY_ROUTING_KEY_MDM_API           = "AQICAHjaUXkOwaFpTGA12n5Ifb6Q0znaDbuU6SyEU0N9fyaf+QFQK5dVUWAVO6PzItHemiCxAAAAajBoBgkqhkiG9w0BBwagWzBZAgEAMFQGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMoI1IQ/I6F8+7mLIEAgEQgCexGzu6/RajcXvGjcoFi0e8XqrDuS9eCDrLvy/lnXm2ILufDelWw2g="
    PAGERDUTY_ROUTING_KEY_NOTIFICATION      = "AQICAHjaUXkOwaFpTGA12n5Ifb6Q0znaDbuU6SyEU0N9fyaf+QFQK5dVUWAVO6PzItHemiCxAAAAajBoBgkqhkiG9w0BBwagWzBZAgEAMFQGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMoI1IQ/I6F8+7mLIEAgEQgCexGzu6/RajcXvGjcoFi0e8XqrDuS9eCDrLvy/lnXm2ILufDelWw2g="
    PAGERDUTY_ROUTING_KEY_DATAVIZ_REPORTING = "AQICAHjaUXkOwaFpTGA12n5Ifb6Q0znaDbuU6SyEU0N9fyaf+QFQK5dVUWAVO6PzItHemiCxAAAAajBoBgkqhkiG9w0BBwagWzBZAgEAMFQGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMoI1IQ/I6F8+7mLIEAgEQgCexGzu6/RajcXvGjcoFi0e8XqrDuS9eCDrLvy/lnXm2ILufDelWw2g="
  }

  providers = {
    aws         = aws
    aws.dr      = aws.dr
    aws.useast1 = aws.useast1
  }
}
