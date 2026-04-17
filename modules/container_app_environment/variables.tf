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

variable "infrastructure_subnet_id" {
  type        = string
  description = "Resource ID of a subnet for infrastructure components. Required when workload_profiles is set."
  default     = null
}

# Default enables workload-profiles mode with a single Consumption profile.
# This mode requires an infrastructure subnet (siehe precondition in main.tf),
# erlaubt aber, später dedizierte Profile (D/E-series) ohne Neuanlage der CAE
# hinzuzufügen — der Wechsel von Consumption-only zu workload-profiles wäre
# sonst ein Breaking Change. Setze [] nur, wenn bewusst auf Consumption-only
# verzichtet werden soll (dann wird auch kein subnet benötigt).
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

