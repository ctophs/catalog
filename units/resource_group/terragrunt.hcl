include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "${include.root.locals.catalog_url}//modules/resource_group?ref=${include.root.locals.catalog_ref}"
}

inputs = {
  name     = values.name
  location = values.location
}
