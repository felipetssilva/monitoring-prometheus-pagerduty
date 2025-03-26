output "aws_iam_role_arn" {
  value = aws_iam_role.snowflake.arn
}

output "snowflake_role" {
  value = module.snowflake_role
}

output "snowflake_warehouse" {
  value = module.snowflake_warehouse
}

output "snowflake_database" {
  value = module.snowflake_database
}

output "snowflake_privatelink" {
  value = module.snowflake_privatelink
}

output "snowflake_sg" {
  value = aws_security_group.ecs_snowflake_exporter.id
}
