variable "namespace" {
  type = string
}

variable "chart_version" {
  type = string
}

variable "destination_server" {
  type = string
}

variable "argocd_project" {
  type = string
  default = "default"
}

variable "cluster" {
  type = string
}

variable "labels" {
  type    = map(string)
  default = {}
}
