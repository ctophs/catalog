mock_provider "azurerm" {}

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

run "plan" {
  command = plan

  assert {
    condition     = length(azurerm_container_app.this.registry) == 0
    error_message = "Registry block must not be created when registry_server is null."
  }
}

run "plan_with_registry_server" {
  command = plan

  variables {
    registry_server = "pwsshared.azurecr.io"
  }

  assert {
    condition     = length(azurerm_container_app.this.registry) == 1
    error_message = "Registry block must be created when both uami_id and registry_server are set."
  }

  assert {
    condition     = azurerm_container_app.this.registry[0].server == "pwsshared.azurecr.io"
    error_message = "Registry server must match the registry_server input."
  }
}
