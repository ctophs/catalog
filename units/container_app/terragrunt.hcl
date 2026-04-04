include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::file:///home/user/terragrunt/catalog//modules/container_app?ref=master"
}

locals {
  # When nested stacks generate this unit, its path is:
  # <stack>/.terragrunt-stack/<env>/.terragrunt-stack/container-app/
  # dirname twice gives <stack>/.terragrunt-stack/<env>/, basename of that is the env name.
  env = basename(dirname(dirname(get_terragrunt_dir())))
}

dependency "uami" {
  config_path = "../uami"

  mock_outputs = {
    id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/mockname/providers/Microsoft.ManagedIdentity/userAssignedIdentities/mockuami"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

dependency "cae" {
  config_path = "../../../../../container_app_environment/.terragrunt-stack/${local.env}/.terragrunt-stack/cae"

  mock_outputs = {
    id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/mockname/providers/Microsoft.App/managedEnvironments/mockenv"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

dependency "resource_group" {
  config_path = "../../../../../container_app_environment/.terragrunt-stack/${local.env}/.terragrunt-stack/cae-resource-group"

  mock_outputs = {
    id       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/mockname"
    name     = "mockname"
    location = "westeurope"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

inputs = {
  name                         = values.name
  resource_group_name          = dependency.resource_group.outputs.name
  container_app_environment_id = dependency.cae.outputs.id
  revision_mode                = try(values.revision_mode, "Single")
  template                     = values.template
  ingress                      = try(values.ingress, null)
  uami_id                      = dependency.uami.outputs.id
  tags                         = try(values.tags, {})
  secrets                      = try(values.secrets, [])
}
