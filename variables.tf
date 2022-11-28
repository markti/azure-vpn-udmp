variable "location" {
  type = string
}
variable "local_ip_address" {
  type = string
}
variable "local_address_space" {
  type = string
}
variable "preshared_key" {
  type = string
}
variable "include_diagnostics" {
  type    = bool
  default = false
}
variable "log_analytics_workspace_name" {
  type = string
}
variable "observability_resource_group" {
  type = string
}
variable "admin_user_id" {
  type = string
}