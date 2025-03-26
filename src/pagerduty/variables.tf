variable "environment" {
  description = "Prefixe de nommage pour pagerduty"
}

variable "channel_ids" {
  type = object({
    datahub = string
    dataviz = string
  })
  default = {
    datahub = ""
    dataviz = ""
  }
}
