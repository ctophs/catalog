include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  catalog = read_terragrunt_config(find_in_parent_folders("catalog.hcl"))
}

terraform {
  source = "${local.catalog.locals.url}//modules/resource_group?ref=${local.catalog.locals.ref}"
}

inputs = {
  name     = values.name
  location = values.location
}
