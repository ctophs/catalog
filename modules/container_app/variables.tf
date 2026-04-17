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

variable "registry_server" {
  type        = string
  description = "Private registry server URL. When set together with uami_id, the Container App authenticates to this registry via the managed identity. Leave null for public images."
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
