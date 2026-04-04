locals {
  catalog_url = "git::file:///home/user/terragrunt/catalog"
  catalog_ref = "master"
}

unit "uami" {
  source = "${local.catalog_url}//units/uami?ref=${local.catalog_ref}"
  path   = "uami"
  values = {
    name                = "${values.name}-uami"
    location            = values.location
    resource_group_name = values.resource_group_name
  }
}

unit "container-app" {
  source = "${local.catalog_url}//units/container_app?ref=${local.catalog_ref}"
  path   = "container-app"
  values = {
    name          = values.name
    revision_mode = try(values.revision_mode, "Single")
    template      = values.template
    ingress       = try(values.ingress, null)
    tags          = try(values.tags, {})
    secrets       = try(values.secrets, [])
  }
}
