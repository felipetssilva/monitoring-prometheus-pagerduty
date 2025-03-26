## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_snowflake_database"></a> [snowflake\_database](#module\_snowflake\_database) | git::ssh://git@gitlab.eulerhermes.io/deployment/datahub/terraform-modules/shared-output.git//import | v1.2.0 |
| <a name="module_snowflake_privatelink"></a> [snowflake\_privatelink](#module\_snowflake\_privatelink) | git::ssh://git@gitlab.eulerhermes.io/deployment/datahub/terraform-modules/shared-output.git//import | v1.2.0 |
| <a name="module_snowflake_role"></a> [snowflake\_role](#module\_snowflake\_role) | git::ssh://git@gitlab.eulerhermes.io/deployment/datahub/terraform-modules/shared-output.git//import | v1.2.0 |
| <a name="module_snowflake_warehouse"></a> [snowflake\_warehouse](#module\_snowflake\_warehouse) | git::ssh://git@gitlab.eulerhermes.io/deployment/datahub/terraform-modules/shared-output.git//import | v1.2.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.snowflake](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.snowflake](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.snowflake](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_security_group.ecs_snowflake_exporter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.snowflake_security_group_rule_http_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.snowflake](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_costcenter"></a> [costcenter](#input\_costcenter) | Added to the resource tags | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Main environment | `string` | n/a | yes |
| <a name="input_iam_role_assume_role_policy"></a> [iam\_role\_assume\_role\_policy](#input\_iam\_role\_assume\_role\_policy) | Assume role of Snowflake's IAM role | `string` | n/a | yes |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | ARN of the KMS key to which we grant access for s3 decrypt | `string` | n/a | yes |
| <a name="input_owner"></a> [owner](#input\_owner) | Added to the resource tags | `string` | n/a | yes |
| <a name="input_product_name"></a> [product\_name](#input\_product\_name) | Added to the resource tags | `string` | n/a | yes |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | Added to the resource tags | `string` | n/a | yes |
| <a name="input_snowflake_environments"></a> [snowflake\_environments](#input\_snowflake\_environments) | List of sub environments where snowflake is available (typically UATM, UATR, etc.) | `list(string)` | n/a | yes |
| <a name="input_source_security_group_id"></a> [source\_security\_group\_id](#input\_source\_security\_group\_id) | Source security group to be used in the security group rule | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC in which we create Snowflake's SG | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_iam_role_arn"></a> [aws\_iam\_role\_arn](#output\_aws\_iam\_role\_arn) | n/a |
| <a name="output_snowflake_database"></a> [snowflake\_database](#output\_snowflake\_database) | n/a |
| <a name="output_snowflake_privatelink"></a> [snowflake\_privatelink](#output\_snowflake\_privatelink) | n/a |
| <a name="output_snowflake_role"></a> [snowflake\_role](#output\_snowflake\_role) | n/a |
| <a name="output_snowflake_warehouse"></a> [snowflake\_warehouse](#output\_snowflake\_warehouse) | n/a |
