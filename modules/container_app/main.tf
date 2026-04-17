resource "azurerm_container_app" "this" {
  name                         = var.name
  resource_group_name          = var.resource_group_name
  container_app_environment_id = var.container_app_environment_id
  revision_mode                = var.revision_mode

  dynamic "secret" {
    for_each = var.secrets
    content {
      name  = secret.value.name
      value = secret.value.value
    }
  }

  template {
    min_replicas = var.template.min_replicas
    max_replicas = var.template.max_replicas

    dynamic "container" {
      for_each = var.template.containers
      content {
        name   = container.value.name
        image  = container.value.image
        cpu    = container.value.cpu
        memory = container.value.memory

        dynamic "env" {
          for_each = container.value.env
          content {
            name        = env.value.name
            value       = env.value.value
            secret_name = env.value.secret_name
          }
        }
      }
    }
  }

  dynamic "ingress" {
    for_each = var.ingress != null ? [var.ingress] : []
    content {
      external_enabled = ingress.value.external_enabled
      target_port      = ingress.value.target_port
      transport        = ingress.value.transport

      traffic_weight {
        latest_revision = true
        percentage      = 100
      }
    }
  }

  dynamic "identity" {
    for_each = var.uami_id != null ? [var.uami_id] : []
    content {
      type         = "UserAssigned"
      identity_ids = [identity.value]
    }
  }
}
