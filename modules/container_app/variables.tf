variable "name" {
  type        = string
  description = "Name of the Container App."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "container_app_environment_id" {
  type        = string
  description = "Resource ID of the Container App Environment."
}

variable "revision_mode" {
  type        = string
  description = "Revision mode of the Container App. Possible values: Single, Multiple."
  default     = "Single"
}

variable "template" {
  type = object({
    min_replicas = optional(number, 0)
    max_replicas = optional(number, 1)
    containers = list(object({
      name   = string
      image  = string
      cpu    = number
      memory = string
      env = optional(list(object({
        name        = string
        value       = optional(string)
        secret_name = optional(string)
      })), [])
    }))
  })
  description = "Template block defining the container(s) and scaling."
}

variable "ingress" {
  type = object({
    external_enabled = optional(bool, false)
    target_port      = number
    transport        = optional(string, "auto")
  })
  description = "Ingress configuration. Set to null to disable ingress."
  default     = null
}

variable "uami_id" {
  type        = string
  description = "Resource ID of the user-assigned managed identity to assign to the Container App."
  default     = null
}

variable "shared_container_registry" {
  type        = string
  description = "Server URL of the shared container registry."
  default     = "pwsshared.azurecr.io"
}

variable "registry_username" {
  type        = string
  description = "Username for registry authentication. Used when uami_id is not set."
  default     = null
}

variable "registry_password_secret_name" {
  type        = string
  description = "Name of the secret containing the registry password. Used when uami_id is not set."
  default     = null
}

variable "secrets" {
  type = list(object({
    name  = string
    value = string
  }))
  description = "Secrets to configure on the Container App."
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the resource."
  default     = {}
}
