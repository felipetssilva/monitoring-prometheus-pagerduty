###
# Generic variables
###

variable "environment" {
  type        = string
  description = "Environment"
}

variable "cf_environment" {
  description = "environment name according to CF nomenclature (AWS Account in general)"
  type        = string
}

variable "product_name" {
  type        = string
  description = "Application name"
}

variable "costcenter" {
  type        = string
  description = "Project supporting cost"
}

variable "owner" {
  type        = string
  description = "Who is in charge. Most probably the project"
}

###
# Specific variables
###

variable "snowflake_environments" {
  type        = list(string)
  description = "subenvironment to monitor for snowflake exporter"
}

variable "blackbox_environments" {
  type        = list(string)
  description = "subenvironment to monitor for blackbox exporter"
}

variable "log_retention_days" {
  type        = number
  description = "Retention days for logs of ECS Services and Lambdas"
}

variable "encrypted_pagerduty_routing_keys" {
  type        = map(string)
  default     = {}
  description = <<EOT
    Map of KMS encrypted pagerduty routing keys declared to alertmanager receivers. List of supported keys is available on
    https://gitlab.eulerhermes.com/deployment/datahub/devops/prometheus/alertmanager/-/blob/master/README.md#supported-env-vars
    Expected values are base64 encoded ciphertext using a KMS key that this stack is allowed to use for unencryption. We
    recommend generating values using the kms-encryptor helper available on https://gitlab.eulerhermes.com/deployment/datahub/devops/kms-encryptor
  EOT
}


variable "cpu_cloudwatch_service" {
  type        = number
  description = "CPU service cloudwatch"
  default     = 256
}

variable "memory_cloudwatch_service" {
  type        = number
  description = "Memory service cloudwatch"
  default     = 512
}

variable "cpu_prometheus_service" {
  type        = number
  description = "CPU service prometheus"
  default     = 256
}

variable "memory_prometheus_service" {
  type        = number
  description = "Memory service prometheus"
  default     = 512
}

variable "cpu_rds_exporter_service" {
  type        = number
  description = "CPU service rds_exporter"
  default     = 256
}

variable "memory_rds_exporter_service" {
  type        = number
  description = "Memory service rds_exporter"
  default     = 512
}

variable "cpu_pushgateway_service" {
  type        = number
  description = "CPU service pushgateway"
  default     = 256
}

variable "memory_pushgateway_service" {
  type        = number
  description = "Memory service pushgateway"
  default     = 512
}
