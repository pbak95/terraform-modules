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

variable "credentials" {
  type = object({
    username = string
    password = string
  })
  default = {
    username = ""
    password = ""
  }
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
  type    = map(string)
  default = {}
}
