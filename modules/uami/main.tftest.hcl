mock_provider "azurerm" {}

run "plan" {
  command = plan

  variables {
    name                = "uami-test"
    location            = "westeurope"
    resource_group_name = "rg-test"
  }
}
