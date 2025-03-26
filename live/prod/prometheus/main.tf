module "monitoring_infrastructure" {
  source = "../../../src/prometheus"

  cf_environment         = local.cf_environment
  environment            = local.environment
  snowflake_environments = local.snowflake_environments
  blackbox_environments  = local.blackbox_environments
  costcenter             = local.costcenter
  owner                  = local.owner
  product_name           = local.product_name
  log_retention_days     = 90

  cpu_cloudwatch_service     = 512
  memory_cloudwatch_service  = 1024
  cpu_prometheus_service     = 512
  memory_prometheus_service  = 1024
  cpu_pushgateway_service    = 512
  memory_pushgateway_service = 1024

  encrypted_pagerduty_routing_keys = {
    PAGERDUTY_ROUTING_KEY_INTERNALS         = "AQICAHjsRmgLyf7lHTyq9bKI+4V7J2l5RGbAuPOsIGoMZU+y2wHIb1HOk7BEiZ3Nx+llyo0SAAAAfjB8BgkqhkiG9w0BBwagbzBtAgEAMGgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMH6YTcLUw1nMQbThdAgEQgDs80F36ssOQi3bLSewyM3V6RsWWLe4DmPf1DWInqssYFJ1umq9Vyw7Yro9SRbPT7V7vl8f6gfxpcVjQ/Q=="
    PAGERDUTY_ROUTING_KEY_KPIF              = "AQICAHjsRmgLyf7lHTyq9bKI+4V7J2l5RGbAuPOsIGoMZU+y2wGT/Oyl62CEVmobbgTyeLQGAAAAfjB8BgkqhkiG9w0BBwagbzBtAgEAMGgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMotApyocR1+gOgCt2AgEQgDuMI+d8neoo1UhHvB9HEH+O9mvE+/Ft6sDJGA4hF8QTarQGQKTpM/nlC3ASA84HF0dohkJ5KP7ZF3hrGg=="
    PAGERDUTY_ROUTING_KEY_BE                = "AQICAHjsRmgLyf7lHTyq9bKI+4V7J2l5RGbAuPOsIGoMZU+y2wEtVTwAdTTScn1IuvgWZ3k7AAAAfjB8BgkqhkiG9w0BBwagbzBtAgEAMGgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMbiUs71F7kD1rpH8AAgEQgDtE8E32qb6fVS8sdp99oBi2I8mc83Ph1HUW+oFWBKiL6r9d5sdqlf910g9TNxkhMMFcWOEh324iHU1ZlA=="
    PAGERDUTY_ROUTING_KEY_CORE              = "AQICAHjsRmgLyf7lHTyq9bKI+4V7J2l5RGbAuPOsIGoMZU+y2wGjpI+7IlFNt+jr7wyl5plfAAAAfjB8BgkqhkiG9w0BBwagbzBtAgEAMGgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMVVjiEhlFCiM9Ys9+AgEQgDtEEyhwxGilQ6Q6avQaMNQqWdOWMA4Xc0V24XdktCV83JyEfNt4oRLI3c2qL4xPLaIYDjZ9zmNukJELYA=="
    PAGERDUTY_ROUTING_KEY_MDM_API           = "AQICAHjsRmgLyf7lHTyq9bKI+4V7J2l5RGbAuPOsIGoMZU+y2wHozMQLzkVr0YlPRFxUdVf/AAAAfjB8BgkqhkiG9w0BBwagbzBtAgEAMGgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQM9J9agmQAR9wkCQEaAgEQgDuqYVEg2kJF696fcSscyuehykFg75g7L+HfKpPwkN/Y3mM8Vhg1ZNWZJIq2towHXY8q4JaIGJt4Fl4mtQ=="
    PAGERDUTY_ROUTING_KEY_NOTIFICATION      = "AQICAHjsRmgLyf7lHTyq9bKI+4V7J2l5RGbAuPOsIGoMZU+y2wFDP1UZPVjg2ij8hNlH856mAAAAfjB8BgkqhkiG9w0BBwagbzBtAgEAMGgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQM4m3YTGDQMLOUJKVLAgEQgDtR4EOHp2HxeG2vSh22+Rb+B/BWaDGiPHOovD5IAPrtwxmdScGtyfylhbmiKFa2nVgWLiRvBj1s0S7rtA=="
    PAGERDUTY_ROUTING_KEY_DATAVIZ_REPORTING = "AQICAHjsRmgLyf7lHTyq9bKI+4V7J2l5RGbAuPOsIGoMZU+y2wGSz1Bcg+Yb8wnsHP08/gcaAAAAfjB8BgkqhkiG9w0BBwagbzBtAgEAMGgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMqqJ2kq1Dk1yx4DZ7AgEQgDuWZv4Mlgz5S/U5jd+1JazoGJM+o4l07EtPcMWvy+eME5dac+lKLAQh+yx+WSrYD/EUNLaSbsoT2sqC1g=="
  }

  providers = {
    aws         = aws
    aws.dr      = aws.dr
    aws.useast1 = aws.useast1
  }
}
