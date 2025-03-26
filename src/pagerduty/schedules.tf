data "pagerduty_schedule" "incident_commander" {
  name = "Incident Commander - schedule"
}

data "pagerduty_schedule" "high_management" {
  name = "IT High Management - schedule"
}

resource "pagerduty_schedule" "business_events_applicative" {
  name        = "[${local.environment}][Datahub] Business Events Applicative Duty Call"
  description = null
  overflow    = null
  teams       = [data.pagerduty_team.datahub_team.id]
  time_zone   = "Europe/Paris"
  layer {
    end                          = null
    name                         = "Layer 1"
    rotation_turn_length_seconds = 604800
    rotation_virtual_start       = "2024-07-01T10:00:00+02:00"
    start                        = "2024-07-01T13:45:30+02:00"
    users                        = [for email in local.schedule_business_events_applicative_user_emails : lookup(local.user_emails_to_ids_map, email, null)]
  }
}

resource "pagerduty_schedule" "datahub_duty_call" {
  name        = "[${local.environment}][Datahub] Devops Duty Call"
  description = "Duty Call Planning for Datahub"
  overflow    = null
  teams       = [data.pagerduty_team.datahub_team.id]
  time_zone   = "Europe/Paris"
  layer {
    end                          = null
    name                         = "Layer 1"
    rotation_turn_length_seconds = 604800
    rotation_virtual_start       = "2024-07-01T10:00:00+02:00"
    start                        = "2024-07-03T11:10:21+02:00"
    users                        = [for email in local.schedule_datahub_duty_call_user_emails : lookup(local.user_emails_to_ids_map, email, null)]
  }


}

resource "pagerduty_schedule" "mdm_cores" {
  name        = "[${local.environment}][Datahub] MDM CORE schedule"
  description = null
  overflow    = null
  teams       = [data.pagerduty_team.datahub_team.id]
  time_zone   = "Europe/Paris"
  layer {
    end                          = null
    name                         = "Layer 1"
    rotation_turn_length_seconds = 604800
    rotation_virtual_start       = "2022-11-14T08:00:00+01:00"
    start                        = "2022-11-17T16:39:23+01:00"
    users                        = [for email in local.schedule_mdm_cores_user_emails : lookup(local.user_emails_to_ids_map, email, null)]
    restriction {
      duration_seconds  = 36000
      start_day_of_week = 1
      start_time_of_day = "08:30:00"
      type              = "weekly_restriction"
    }
    restriction {
      duration_seconds  = 36000
      start_day_of_week = 2
      start_time_of_day = "08:30:00"
      type              = "weekly_restriction"
    }
    restriction {
      duration_seconds  = 36000
      start_day_of_week = 3
      start_time_of_day = "08:30:00"
      type              = "weekly_restriction"
    }
    restriction {
      duration_seconds  = 36000
      start_day_of_week = 4
      start_time_of_day = "08:30:00"
      type              = "weekly_restriction"
    }
    restriction {
      duration_seconds  = 36000
      start_day_of_week = 5
      start_time_of_day = "08:30:00"
      type              = "weekly_restriction"
    }
  }


}

resource "pagerduty_schedule" "dataviz" {
  description = "[${local.environment}][Datahub] Dataviz escalation"
  name        = "[${local.environment}][Datahub] Dataviz"
  overflow    = null
  teams       = [data.pagerduty_team.datahub_team.id]
  time_zone   = "Europe/Paris"
  layer {
    end                          = null
    name                         = "Layer 1"
    rotation_turn_length_seconds = 604800
    rotation_virtual_start       = "2024-10-21T09:00:00+02:00"
    start                        = "2024-10-21T09:41:17+02:00"
    users                        = [lookup(local.user_emails_to_ids_map, "youness.lagrini.ext2@allianz-trade.com", null)]
  }
}
