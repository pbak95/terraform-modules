variable "chart_version" {
  type = string
}

variable "admin_password" {
  type      = string
  sensitive = true
}

variable "namespace" {
  type = string
}

#variable "tls_secret_name" {
#  type = string
#}

#variable "base_domain" {
#  type = string
#}
