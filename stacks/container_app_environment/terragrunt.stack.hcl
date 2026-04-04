# Terragrunt-Stacks unterstuetzen kein include — daher muss catalog.hcl
# hier direkt gelesen werden, statt ueber root.hcl wie bei Units.
locals {
  catalog = read_terragrunt_config(find_in_parent_folders("catalog.hcl"))
}

unit "cae-resource-group" {
  source = "${local.catalog.locals.url}//units/resource_group?ref=${local.catalog.locals.ref}"
  path   = "cae-resource-group"
  values = {
    name     = values.resource_group_name
    location = values.location
  }
}

unit "cae" {
  source = "${local.catalog.locals.url}//units/container_app_environment?ref=${local.catalog.locals.ref}"
  path   = "cae"
  values = {
    name                     = values.name
    location                 = values.location
    infrastructure_subnet_id = try(values.infrastructure_subnet_id, null)
  }
}

unit "uami-resource-group" {
  source = "${local.catalog.locals.url}//units/resource_group?ref=${local.catalog.locals.ref}"
  path   = "uami-resource-group"
  values = {
    name     = values.uami_resource_group_name
    location = values.location
  }
}

unit "uami" {
  source = "${local.catalog.locals.url}//units/uami?ref=${local.catalog.locals.ref}"
  path   = "uami"
  values = {
    name                = values.name
    location            = values.location
    resource_group_name = values.uami_resource_group_name
  }
}
