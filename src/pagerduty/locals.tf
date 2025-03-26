locals {
  # Teams and users
  environment            = upper(var.environment)
  user_emails_to_ids_map = { for user in data.pagerduty_users.users.users : user.email => user.id }

  # Schedules
  schedule_business_events_applicative_user_emails = [
    "marc.carneherrera.ext@allianz-trade.com",
    "joan.mariyern.ext@allianz-trade.com",
    "josemiguel.arranz.ext@allianz-trade.com",
    "othman.seqqat.ext@allianz-trade.com",
  ]
  schedule_datahub_duty_call_user_emails = [
    "gregory.solocha.ext@allianz-trade.com",
    "jean.hublart.ext@allianz-trade.com",
    "david.tissot.ext@allianz-trade.com",
    "kevin.andrieux.ext@allianz-trade.com"
  ]
  schedule_mdm_cores_user_emails = ["stephane.renac.ext@allianz-trade.com"]
}
