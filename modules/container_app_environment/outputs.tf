output "id" {
  value       = azurerm_container_app_environment.this.id
  description = "Resource ID of the Container App Environment."
}

output "name" {
  value       = azurerm_container_app_environment.this.name
  description = "Name of the Container App Environment."
}

output "static_ip_address" {
  value       = azurerm_container_app_environment.this.static_ip_address
  description = "Static IP address of the Container App Environment."
}

output "default_domain" {
  value       = azurerm_container_app_environment.this.default_domain
  description = "Default domain of the Container App Environment."
}
