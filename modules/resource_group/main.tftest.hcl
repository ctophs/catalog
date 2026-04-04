mock_provider "azurerm" {}

run "plan" {
  command = plan

  variables {
    name     = "rg-test"
    location = "westeurope"
  }
}
