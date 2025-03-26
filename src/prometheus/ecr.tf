data "aws_ecr_image" "alertmanagers" {
  for_each        = local.alertmanagers
  registry_id     = local.ecr_repository_id
  repository_name = each.value.image_name
  image_tag       = each.value.image_tag
}