include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "${include.root.locals.catalog_url}//modules/uami?ref=${include.root.locals.catalog_ref}"
}

inputs = {
  name                = values.name
  location            = values.location
  resource_group_name = values.resource_group_name
}
