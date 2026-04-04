variable "name" {
  type        = string
  description = "Name of the user-assigned managed identity."
}

variable "location" {
  type        = string
  description = "Azure region where the resource will be deployed."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the resource."
  default     = {}
}
