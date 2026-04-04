variable "name" {
  type        = string
  description = "Name of the Container App Environment."
}

variable "location" {
  type        = string
  description = "Azure region where the resource will be deployed."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Resource ID of a Log Analytics workspace. Required for workload profile environments."
  default     = null
}

variable "infrastructure_subnet_id" {
  type        = string
  description = "Resource ID of a subnet for infrastructure components. Required when workload_profiles is set."
  default     = null
}

variable "workload_profiles" {
  type = list(object({
    name                  = string
    workload_profile_type = string
    minimum_count         = optional(number)
    maximum_count         = optional(number)
  }))
  description = "Workload profiles for the Container App Environment."
  default = [{
    name                  = "Consumption"
    workload_profile_type = "Consumption"
  }]
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the resource."
  default     = {}
}
