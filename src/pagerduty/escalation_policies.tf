resource "pagerduty_escalation_policy" "mdm_core" {
  name        = "[${local.environment}][Datahub] MDM CORE escalation"
  description = null
  num_loops   = 0
  teams       = [data.pagerduty_team.datahub_team.id]
  rule {
    escalation_delay_in_minutes = 30
    escalation_rule_assignment_strategy {
      type = "assign_to_everyone"
    }
    target {
      id   = pagerduty_schedule.mdm_cores.id
      type = "schedule_reference"
    }
  }
  rule {
    escalation_delay_in_minutes = 30
    escalation_rule_assignment_strategy {
      type = "assign_to_everyone"
    }
    target {
      id   = lookup(local.user_emails_to_ids_map, "ridha.nabli@allianz-trade.com", null)
      type = "user_reference"
    }
  }


}

resource "pagerduty_escalation_policy" "business_events" {
  name        = "[${local.environment}][Datahub] BusinessEvent escalation Policy"
  description = "for datahub"
  num_loops   = 0
  teams       = [data.pagerduty_team.datahub_team.id]
  rule {
    escalation_delay_in_minutes = 60
    escalation_rule_assignment_strategy {
      type = "assign_to_everyone"
    }
    target {
      id   = pagerduty_schedule.business_events_applicative.id
      type = "schedule_reference"
    }
  }
  rule {
    escalation_delay_in_minutes = 30
    escalation_rule_assignment_strategy {
      type = "assign_to_everyone"
    }
    target {
      id   = lookup(local.user_emails_to_ids_map, "marc.carneherrera.ext@allianz-trade.com", null)
      type = "user_reference"
    }
  }


}

resource "pagerduty_escalation_policy" "datahub_basic" {
  name        = "[${local.environment}][Datahub] Basic Escalation Policy"
  description = null
  num_loops   = 0
  teams       = [data.pagerduty_team.datahub_team.id]
  rule {
    escalation_delay_in_minutes = 10
    escalation_rule_assignment_strategy {
      type = "assign_to_everyone"
    }
    target {
      id   = pagerduty_schedule.datahub_duty_call.id
      type = "schedule_reference"
    }
  }
  rule {
    escalation_delay_in_minutes = 10
    escalation_rule_assignment_strategy {
      type = "assign_to_everyone"
    }
    target {
      id   = lookup(local.user_emails_to_ids_map, "kevin.andrieux.ext@allianz-trade.com", null)
      type = "user_reference"
    }
  }
  rule {
    escalation_delay_in_minutes = 10
    escalation_rule_assignment_strategy {
      type = "assign_to_everyone"
    }
    target {
      id   = lookup(local.user_emails_to_ids_map, "ridha.nabli@allianz-trade.com", null)
      type = "user_reference"
    }
  }
  rule {
    escalation_delay_in_minutes = 30
    escalation_rule_assignment_strategy {
      type = "assign_to_everyone"
    }
    target {
      id   = data.pagerduty_schedule.incident_commander.id
      type = "schedule_reference"
    }
  }
  rule {
    escalation_delay_in_minutes = 30
    escalation_rule_assignment_strategy {
      type = "assign_to_everyone"
    }
    target {
      id   = data.pagerduty_schedule.high_management.id
      type = "schedule_reference"
    }
  }


}


resource "pagerduty_escalation_policy" "dataviz" {
  description = "[${local.environment}][Datahub] Dataviz escalation"
  name        = "[${local.environment}][Datahub] Dataviz escalation"
  num_loops   = 0
  teams       = [data.pagerduty_team.datahub_team.id]
  rule {
    escalation_delay_in_minutes = 30
    escalation_rule_assignment_strategy {
      type = "assign_to_everyone"
    }
    target {
      id   = pagerduty_schedule.dataviz.id
      type = "schedule_reference"
    }
  }
  rule {
    escalation_delay_in_minutes = 30
    escalation_rule_assignment_strategy {
      type = "assign_to_everyone"
    }
    target {
      id   = lookup(local.user_emails_to_ids_map, "kacper.barwicki@eulerhermes.com", null)
      type = "user_reference"
    }
  }
}
