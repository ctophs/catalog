resource "azurerm_container_app_environment" "this" {
  name                       = var.name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  infrastructure_subnet_id   = var.infrastructure_subnet_id
  log_analytics_workspace_id = var.log_analytics_workspace_id
  tags                       = var.tags

  dynamic "workload_profile" {
    for_each = var.workload_profiles
    content {
      name                  = workload_profile.value.name
      workload_profile_type = workload_profile.value.workload_profile_type
      minimum_count         = workload_profile.value.minimum_count
      maximum_count         = workload_profile.value.maximum_count
    }
  }

  lifecycle {
    precondition {
      condition     = length(var.workload_profiles) == 0 || var.infrastructure_subnet_id != null
      error_message = "infrastructure_subnet_id is required when workload_profiles are configured."
    }
  }
}
