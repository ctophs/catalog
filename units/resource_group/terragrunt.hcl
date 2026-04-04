include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::file:///home/user/terragrunt/catalog//modules/resource_group?ref=master"
}

inputs = {
  name     = values.name
  location = values.location
}
