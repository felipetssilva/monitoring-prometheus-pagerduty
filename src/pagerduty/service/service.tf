resource "pagerduty_service" "service" {
  name                    = var.name
  description             = var.description
  escalation_policy       = var.escalation_policy
  alert_creation          = "create_alerts_and_incidents"
  acknowledgement_timeout = "null"
  auto_resolve_timeout    = "null"
  response_play           = null
  incident_urgency_rule {
    type    = "constant"
    urgency = "high"
  }


}

# resource "pagerduty_slack_connection" "slack" {
#   source_id         = pagerduty_service.service.id
#   source_type       = "service_reference"
#   workspace_id      = "TB012KZ27" # EH IT workspace
#   channel_id        = var.channel_id
#   notification_type = "responder"

#   config {
#     events = [
#       "incident.triggered",
#       "incident.acknowledged",
#       "incident.escalated",
#       "incident.resolved",
#       "incident.reassigned",
#       "incident.annotated",
#       "incident.unacknowledged",
#       "incident.delegated",
#       "incident.priority_updated",
#       "incident.responder.added",
#       "incident.responder.replied",
#       "incident.status_update_published",
#       "incident.reopened"
#     ]
#   }

# }
