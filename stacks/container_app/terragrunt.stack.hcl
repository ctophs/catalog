locals {
  catalog = read_terragrunt_config(find_in_parent_folders("catalog.hcl"))
}

unit "uami" {
  source = "${local.catalog.locals.url}//units/uami?ref=${local.catalog.locals.ref}"
  path   = "uami"
  values = {
    name                = "${values.name}-uami"
    location            = values.location
    resource_group_name = values.resource_group_name
  }
}

unit "container-app" {
  source = "${local.catalog.locals.url}//units/container_app?ref=${local.catalog.locals.ref}"
  path   = "container-app"
  values = {
    module        = "container_app"
    name          = values.name
    revision_mode = try(values.revision_mode, "Single")
    template      = values.template
    ingress       = try(values.ingress, null)
    tags          = try(values.tags, {})
    secrets       = try(values.secrets, [])
  }
}
