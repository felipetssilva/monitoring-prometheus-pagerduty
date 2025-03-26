output "cluster_id" {
  value = module.cluster.cluster_id
}

output "cluster_name" {
  value = module.cluster.cluster_name
}

output "alb_arn" {
  value = module.alb.arn
}

output "alb_dns_name" {
  value = module.alb.dns_name
}

output "alb_zone_id" {
  value = module.alb.zone_id
}

output "alb_security_group_id" {
  value = module.alb.security_group_id
}

output "task_execution_role_arn" {
  value = module.cluster.task_execution_role.arn
}

output "alb_listener_arn" {
  value = module.alb.listener_arn
}
