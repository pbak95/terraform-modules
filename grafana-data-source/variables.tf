variable "type" {
  type    = string
  default = "loki"
}

variable "name" {
  type = string
}

variable "url" {
  type = string
}

variable "username" {
  type      = string
  default   = ""
  sensitive = true
}

variable "password" {
  type      = string
  default   = ""
  sensitive = true
}

variable "basic_auth_enabled" {
  type    = bool
  default = false
}

variable "tls_skip_verify" {
  type    = bool
  default = false
}

variable "http_headers" {
  type = map(string)
  default = {}
}
