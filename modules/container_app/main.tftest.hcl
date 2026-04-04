mock_provider "azurerm" {}

run "plan" {
  command = plan

  variables {
    name                         = "ca-test"
    resource_group_name          = "rg-test"
    container_app_environment_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.App/managedEnvironments/cae-test"
    uami_id                      = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.ManagedIdentity/userAssignedIdentities/uami-test"
    template = {
      min_replicas = 0
      max_replicas = 1
      containers = [{
        name   = "app"
        image  = "nginx:latest"
        cpu    = 0.25
        memory = "0.5Gi"
      }]
    }
    ingress = {
      external_enabled = false
      target_port      = 8080
    }
  }
}
