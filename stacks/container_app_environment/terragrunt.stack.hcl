unit "cae-resource-group" {
  source = "../../units/resource_group"
  path   = "cae-resource-group"
  values = {
    name     = values.resource_group_name
    location = values.location
  }
}

unit "cae" {
  source = "../../units/container_app_environment"
  path   = "cae"
  values = {
    name                     = values.name
    location                 = values.location
    infrastructure_subnet_id = try(values.infrastructure_subnet_id, null)
  }
}

unit "uami-resource-group" {
  source = "../../units/resource_group"
  path   = "uami-resource-group"
  values = {
    name     = values.uami_resource_group_name
    location = values.location
  }
}

unit "uami" {
  source = "../../units/uami"
  path   = "uami"
  values = {
    name                = values.name
    location            = values.location
    resource_group_name = values.uami_resource_group_name
  }
}
