module "BE" {
  source = "./service"

  name              = "[${local.environment}][Datahub] Business Events Connectors"
  description       = "This service gathers all Datahub Business Events Connectors "
  channel_id        = var.channel_ids.datahub
  escalation_policy = pagerduty_escalation_policy.datahub_basic.id
}

module "CORE" {
  source = "./service"

  name              = "[${local.environment}][Datahub] Core Platform"
  description       = "This service gathers all Datahub Streaming APIs (e.g. cloudevents, schemaregistry) and internal processes from the streaming platform."
  channel_id        = var.channel_ids.datahub
  escalation_policy = pagerduty_escalation_policy.datahub_basic.id
}

module "dataviz" {
  source = "./service"

  name              = "[${local.environment}][Datahub] Dataviz - Reporting"
  description       = null
  channel_id        = var.channel_ids.dataviz
  escalation_policy = pagerduty_escalation_policy.dataviz.id
}

module "devops" {
  source = "./service"

  name              = "[${local.environment}][Datahub] DevOps Internals"
  description       = "This service gathers all internal Datahub processes and technical APIs."
  channel_id        = var.channel_ids.datahub
  escalation_policy = pagerduty_escalation_policy.datahub_basic.id
}

module "edw" {
  source = "./service"

  name              = "[${local.environment}][Datahub] Enterprise Datawarehouse (EDW)"
  description       = "This service gathers all elements related to Datahub Enterprise Datawarehouse (e.g. Snowflake, Ingestion Batches)"
  channel_id        = var.channel_ids.datahub
  escalation_policy = pagerduty_escalation_policy.dataviz.id
}

module "kpi_factory" {
  source = "./service"

  name              = "[${local.environment}][Datahub] KPI Factory"
  description       = "This service gathers Datahub KPI Factory APIs and internal processes."
  channel_id        = var.channel_ids.datahub
  escalation_policy = pagerduty_escalation_policy.datahub_basic.id
}

module "mdm" {
  source = "./service"

  name              = "[${local.environment}][Datahub] MDM-API"
  description       = "All services regarding MDM-API managed by Datahub"
  channel_id        = var.channel_ids.datahub
  escalation_policy = pagerduty_escalation_policy.datahub_basic.id
}

module "mdm-core" {
  source = "./service"

  name              = "[${local.environment}][Datahub] MDM CORE"
  description       = "MDM CORE database providing "
  channel_id        = var.channel_ids.datahub
  escalation_policy = pagerduty_escalation_policy.mdm_core.id
}
