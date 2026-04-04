locals {
  catalog_url = "git::file:///home/user/terragrunt/catalog"
  catalog_ref = "master"
}

unit "cae-resource-group" {
  source = "${local.catalog_url}//units/resource_group?ref=${local.catalog_ref}"
  path   = "cae-resource-group"
  values = {
    name     = values.resource_group_name
    location = values.location
  }
}

unit "cae" {
  source = "${local.catalog_url}//units/container_app_environment?ref=${local.catalog_ref}"
  path   = "cae"
  values = {
    name                     = values.name
    location                 = values.location
    infrastructure_subnet_id = try(values.infrastructure_subnet_id, null)
  }
}

unit "uami-resource-group" {
  source = "${local.catalog_url}//units/resource_group?ref=${local.catalog_ref}"
  path   = "uami-resource-group"
  values = {
    name     = values.uami_resource_group_name
    location = values.location
  }
}

unit "uami" {
  source = "${local.catalog_url}//units/uami?ref=${local.catalog_ref}"
  path   = "uami"
  values = {
    name                = values.name
    location            = values.location
    resource_group_name = values.uami_resource_group_name
  }
}
