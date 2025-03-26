data "pagerduty_users" "users" {
  depends_on = [data.pagerduty_team.datahub_team]
  team_ids   = [data.pagerduty_team.datahub_team.id]
}

data "pagerduty_team" "datahub_team" {
  name = "DataHub"
}
