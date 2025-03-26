variable "costcenter" {
  type        = string
  description = "Added to the resource tags"
}

variable "owner" {
  type        = string
  description = "Added to the resource tags"
}

variable "product_name" {
  type        = string
  description = "Added to the resource tags"
}

variable "service_name" {
  type        = string
  description = "Added to the resource tags"
}

variable "environment" {
  type        = string
  description = "Main environment"
}

variable "cf_environment" {
  type        = string
  description = "Main cloud fondation environment"
}

variable "snowflake_environments" {
  type        = list(string)
  description = "List of sub environments where snowflake is available (typically UATM, UATR, etc.)"
}

variable "iam_role_assume_role_policy" {
  type        = string
  description = "Assume role of Snowflake's IAM role"
}

variable "kms_key_arn" {
  type        = string
  description = "ARN of the KMS key to which we grant access for s3 decrypt"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC in which we create Snowflake's SG"
}
