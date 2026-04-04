include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  catalog = read_terragrunt_config(find_in_parent_folders("catalog.hcl"))
}

terraform {
  source = "${local.catalog.locals.url}//modules/container_app_environment?ref=${local.catalog.locals.ref}"
}

dependency "resource_group" {
  config_path = "../cae-resource-group"

  mock_outputs = {
    id       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/mockname"
    name     = "mockname"
    location = "westeurope"
  }
}

inputs = {
  name                     = values.name
  location                 = values.location
  resource_group_name      = dependency.resource_group.outputs.name
  infrastructure_subnet_id = try(values.infrastructure_subnet_id, null)
}
