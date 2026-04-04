output "id" {
  value       = azurerm_container_app.this.id
  description = "Resource ID of the Container App."
}

output "name" {
  value       = azurerm_container_app.this.name
  description = "Name of the Container App."
}

output "fqdn" {
  value       = try(azurerm_container_app.this.ingress[0].fqdn, null)
  description = "FQDN of the Container App ingress. Only set when ingress is configured."
}

output "outbound_ip_addresses" {
  value       = azurerm_container_app.this.outbound_ip_addresses
  description = "Outbound IP addresses of the Container App."
}
