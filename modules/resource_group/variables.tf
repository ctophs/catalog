variable "name" {
  type        = string
  description = "Name of the resource group."
}

variable "location" {
  type        = string
  description = "Azure region where the resource group will be created."
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the resource group."
  default     = {}
}
