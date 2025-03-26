########################################################################################################################
#
# GLOBAL
#
########################################################################################################################

variable "tags" {
  type        = map(string)
  description = "A list of tags to apply to resources that handles it"
}

variable "short_description" {
  type        = string
  description = "A short description without spaces and letters or -"
}

variable "product_name" {
  type        = string
  description = "Short application name"
}

variable "environment" {
  type        = string
  description = "Environment"
}

variable "custom_environment" {
  type        = string
  description = "Custom environment to be included in lambda name"
  default     = ""
}

variable "attach_managed_sg" {
  type        = bool
  description = "Enable or disable the attachment of the managed security group for lambda"
  default     = false
}

variable "managed_sg_environment" {
  type        = string
  description = "Managed security group environment code (dev, int, uat, prod)"
  default     = ""
}

########################################################################################################################
#
# Lambda
#
########################################################################################################################
variable "architectures" {
  type        = list(string)
  description = "Instruction set architecture for your Lambda function"
  default     = ["x86_64"]
}

variable "description" {
  type        = string
  description = "A description of the function"
}

variable "s3_bucket" {
  type        = string
  description = "The S3 bucket location containing the function's deployment package. This bucket must reside in the same AWS region where you are creating the Lambda function."
  default     = null
}

variable "s3_key" {
  type        = string
  description = "The S3 key of an object containing the function's deployment package."
  default     = null
}

variable "s3_object_version" {
  type        = string
  description = "The object version containing the function's deployment package."
  default     = null
}

variable "role_arn" {
  type        = string
  description = "Lambda Execution role ARN attached to lambda, if empty basic execution role is created. Default: empty"
  default     = ""
}

# We need to provide an explicit count because of terraform issue
variable "provided_role" {
  type        = string
  description = "This flag ditermine whether `role_arn is provided or not `. Default: false"
  default     = false
}

variable "role_policy_arns" {
  type        = list(string)
  description = "List of policy ARN to attach to lambda execution role. Default: []"
  default     = []
}

# We need to provide an explicit count because of terraform issue
variable "role_policy_count" {
  type        = number
  description = "Number of policies to attach to lambda execution role (Required if role_policy_arns is provided). Default: 0"
  default     = 0
}

variable "vpc_subnet_ids" {
  type        = list(string)
  description = "List of subnets for lambda VPC config. Default: []"
  default     = []
}

variable "security_group_ids" {
  type        = list(string)
  description = "List of security groups for lambda VPC config. Default: []"
  default     = []
}

variable "handler" {
  type        = string
  description = "Code entrypoint. (function name usually)"
}

variable "runtime" {
  description = "Execution runtime (See https://docs.aws.amazon.com/lambda/latest/dg/API_CreateFunction.html#SSS-CreateFunction-request-Runtime)"
  type        = string
  default     = null
}

variable "memory" {
  type        = number
  description = "Amount of memory in MB lambda can use at runtime. Default: 128"
  default     = 128
}

variable "timeout" {
  type        = number
  description = "Max execution time in seconds. Default: 3"
  default     = 3
}

variable "concurrency" {
  type        = number
  description = "Amount of reserved  concurrent executions, 0 desable lambda from being triggered, -1 no limitation. Default -1"
  default     = -1
}

variable "kms_key_arn" {
  type        = string
  description = "The ARN for the KMS encryption key."
  default     = ""
}

variable "tracing_config" {
  type        = string
  description = "Tracing settings of the function. Default: PassThrough"
  default     = "PassThrough"
}

variable "env" {
  type        = map(string)
  description = "Lambda environment variables. Default: {}"
  default     = {}
}

variable "source_services" {
  type        = list(string)
  description = "The services who is getting the permissions to invoke the lambda. Default []"
  default     = []
}

variable "source_arns" {
  type        = list(string)
  description = "The ARNs of the resources whoservices who is getting the permissions to invoke the lambda. Default []"
  default     = []
}

variable "cloudwatch_retention_days" {
  type        = number
  description = "Number of days to keep logs in cloudwatch. Default 30"
  default     = 30
}

variable "cloudwatch_log_group_description" {
  type        = string
  description = "Description of the CloudWatch Log Group"
  default     = "Cloudfront log group for Lambda"
}

variable "publish" {
  type        = bool
  description = "Tells if the lambda versioning is enabled"
  default     = false
}

variable "lambda_alias" {
  type        = string
  description = "Alias name of lambda latest version."
  default     = "PROD"
}

variable "lambda_alias_function_version" {
  type        = string
  description = "Alias function version of lambda version."
  default     = null
}

variable "lambda_layers" {
  type        = list(string)
  description = "List of lambda layer version ARN. length(lambda_layers) <= 5"
  default     = []
}

variable "provisioned_concurrency" {
  type        = number
  description = "Number of provisioned & warmed lambda instances. !!PROVISIONED CAPACITY IS CHARGED EVEN IF LAMBDA IS NOT USED!!  Default: 0, Constraint: value between 0 & 10"
  default     = 0
}

variable "account_id" {
  type        = string
  description = "The AWS Account ID number of the account that owns or contains the calling entity"
  default     = null
}

variable "dead_letter_config_arn" {
  type        = string
  description = "The ARN of an SNS topic or SQS queue to notify when an invocation fails. If this option is used, the function's IAM role must be granted suitable access to write to the target object, which means allowing either the sns:Publish or sqs:SendMessage action on this ARN, depending on which service is targeted."
  default     = ""
}

variable "ephemeral_storage" {
  type        = number
  description = "Ephemeral Storage(/tmp) allows you to configure the storage upto 10 GB. The default value set to 512 MB."
  default     = 512
}

variable "efs_access_point_arn" {
  type        = string
  default     = null
  description = "the efs access point arn used by the lambda to use the EFS"
}

variable "image_uri" {
  type        = string
  default     = null
  description = "Docker image uri for custom runtimes"
}

variable "docker_cmd" {
  type        = list(string)
  default     = []
  description = "Docker image command"
}

variable "docker_entrypoint" {
  type        = list(string)
  default     = []
  description = "Docker image entrypoint"
}

variable "docker_working_directory" {
  type        = string
  default     = null
  description = "Docker image entrypoint"
}

variable "package_type" {
  type        = string
  default     = "Zip"
  description = "Lambda package type. Valid values are Zip and Image"
}

variable "enable_snapstart" {
  type        = bool
  default     = true
  description = "To enable snapstart for Lambda. Only available for Java11 runtime"
}
