locals {
  blackbox_ecs_task_definition = {
    blackbox = {
      image_name     = "clouddevops/prometheus_blackbox_exporter"
      image_tag      = "v0.25.0-amd"
      container_port = 9115
      cpu            = 256
      memory         = 512
      additional_security_group_ids = [
        module.networkdata.allow_nat2_sg_id
      ]
      volumes = {
        blackbox_exporter = {
          container_path     = "/etc/blackbox_exporter"
          efs_root_directory = "/blackbox"
        }
      }
    }
  }
}