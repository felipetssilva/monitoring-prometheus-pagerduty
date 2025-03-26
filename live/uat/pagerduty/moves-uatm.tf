moved {
  from = module.pagerduty-uatm.pagerduty_service.business_events_connectors
  to   = module.pagerduty-uatm.module.BE.pagerduty_service.service
}
moved {
  from = module.pagerduty-uatm.pagerduty_service.core_platform
  to   = module.pagerduty-uatm.module.CORE.pagerduty_service.service
}
moved {
  from = module.pagerduty-uatm.pagerduty_service.dataviz_reporting
  to   = module.pagerduty-uatm.module.dataviz.pagerduty_service.service
}
moved {
  from = module.pagerduty-uatm.pagerduty_service.devops_internals
  to   = module.pagerduty-uatm.module.devops.pagerduty_service.service
}
moved {
  from = module.pagerduty-uatm.pagerduty_service.enterprise_datawarehouse
  to   = module.pagerduty-uatm.module.edw.pagerduty_service.service
}
moved {
  from = module.pagerduty-uatm.pagerduty_service.kpi_factory
  to   = module.pagerduty-uatm.module.kpi_factory.pagerduty_service.service
}
moved {
  from = module.pagerduty-uatm.pagerduty_service.mdm_api
  to   = module.pagerduty-uatm.module.mdm.pagerduty_service.service
}
moved {
  from = module.pagerduty-uatm.pagerduty_service.mdm_core
  to   = module.pagerduty-uatm.module.mdm-core.pagerduty_service.service
}
