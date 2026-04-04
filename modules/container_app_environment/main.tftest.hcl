mock_provider "azurerm" {}

run "plan_with_subnet" {
  command = plan

  variables {
    name                     = "cae-test"
    location                 = "westeurope"
    resource_group_name      = "rg-test"
    infrastructure_subnet_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Network/virtualNetworks/vnet-test/subnets/snet-cae-test"
  }
}

run "plan_without_workload_profiles" {
  command = plan

  variables {
    name                = "cae-test"
    location            = "westeurope"
    resource_group_name = "rg-test"
    workload_profiles   = []
  }
}
