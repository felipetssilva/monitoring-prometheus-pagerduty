moved {
  from = module.pagerduty-uatr.pagerduty_service.business_events_connectors
  to   = module.pagerduty-uatr.module.BE.pagerduty_service.service
}
moved {
  from = module.pagerduty-uatr.pagerduty_service.core_platform
  to   = module.pagerduty-uatr.module.CORE.pagerduty_service.service
}
moved {
  from = module.pagerduty-uatr.pagerduty_service.dataviz_reporting
  to   = module.pagerduty-uatr.module.dataviz.pagerduty_service.service
}
moved {
  from = module.pagerduty-uatr.pagerduty_service.devops_internals
  to   = module.pagerduty-uatr.module.devops.pagerduty_service.service
}
moved {
  from = module.pagerduty-uatr.pagerduty_service.enterprise_datawarehouse
  to   = module.pagerduty-uatr.module.edw.pagerduty_service.service
}
moved {
  from = module.pagerduty-uatr.pagerduty_service.kpi_factory
  to   = module.pagerduty-uatr.module.kpi_factory.pagerduty_service.service
}
moved {
  from = module.pagerduty-uatr.pagerduty_service.mdm_api
  to   = module.pagerduty-uatr.module.mdm.pagerduty_service.service
}
moved {
  from = module.pagerduty-uatr.pagerduty_service.mdm_core
  to   = module.pagerduty-uatr.module.mdm-core.pagerduty_service.service
}
