include "root" {
  path = find_in_parent_folders("root.hcl")
}

inputs = {
  name                = values.name
  location            = values.location
  resource_group_name = values.resource_group_name
}
