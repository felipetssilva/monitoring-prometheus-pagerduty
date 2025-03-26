##############################################################
#
# Lambda Outputs
#
##############################################################

output "arn" {
  value       = aws_lambda_function.lambda.arn
  description = "The ARN identifying created lambda function."
}

output "lambda_name" {
  value       = aws_lambda_function.lambda.function_name
  description = "The name of created lambda function."
}

output "qualified_arn" {
  value       = aws_lambda_function.lambda.qualified_arn
  description = "The ARN identifying created lambda function version."
}

output "invoke_arn" {
  value       = aws_lambda_function.lambda.invoke_arn
  description = " The ARN to be used for invoking Lambda Function from API Gateway, CW Events..etc"
}

output "version" {
  value       = aws_lambda_function.lambda.version
  description = "Latest published version of the lambda function."
}

output "last_modified" {
  value       = aws_lambda_function.lambda.last_modified
  description = "The date this resource was last modified."
}

output "source_code_hash" {
  value       = aws_lambda_function.lambda.source_code_hash
  description = "Base64-encoded representation of raw SHA-256 sum of the lambda file."
}

output "source_code_size" {
  value       = aws_lambda_function.lambda.source_code_size
  description = "The size in bytes of the function .zip file."
}

##############################################################
#
# Lambda Alias Outputs
#
##############################################################

output "alias_name" {
  value       = aws_lambda_alias.lambda_alias[*].name
  description = " The ARN of the lambda alias name."
}

output "alias_arn" {
  value       = aws_lambda_alias.lambda_alias[*].arn
  description = " The ARN of the lambda alias."
}

output "alias_invoke_arn" {
  value       = aws_lambda_alias.lambda_alias[*].invoke_arn
  description = " The ARN to be used for invoking Lambda Function from API Gateway"
}

##############################################################
#
# Lambda CW Log Group Outputs
#
##############################################################

output "log_group_name" {
  value       = aws_cloudwatch_log_group.lambda_cloudwatch_log_group.name
  description = "Log Group Name."
}

output "log_group_arn" {
  value       = aws_cloudwatch_log_group.lambda_cloudwatch_log_group.arn
  description = "Log Group ARN."
}
