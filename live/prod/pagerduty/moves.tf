moved {
  from = module.pagerduty.pagerduty_service.business_events_connectors
  to   = module.pagerduty.module.BE.pagerduty_service.service
}
moved {
  from = module.pagerduty.pagerduty_service.core_platform
  to   = module.pagerduty.module.CORE.pagerduty_service.service
}
moved {
  from = module.pagerduty.pagerduty_service.dataviz_reporting
  to   = module.pagerduty.module.dataviz.pagerduty_service.service
}
moved {
  from = module.pagerduty.pagerduty_service.devops_internals
  to   = module.pagerduty.module.devops.pagerduty_service.service
}
moved {
  from = module.pagerduty.pagerduty_service.enterprise_datawarehouse
  to   = module.pagerduty.module.edw.pagerduty_service.service
}
moved {
  from = module.pagerduty.pagerduty_service.kpi_factory
  to   = module.pagerduty.module.kpi_factory.pagerduty_service.service
}
moved {
  from = module.pagerduty.pagerduty_service.mdm_api
  to   = module.pagerduty.module.mdm.pagerduty_service.service
}
moved {
  from = module.pagerduty.pagerduty_service.mdm_core
  to   = module.pagerduty.module.mdm-core.pagerduty_service.service
}
