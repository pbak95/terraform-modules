variable "namespace" {
  type = string
}

variable "labels" {
  type    = map(string)
  default = {}
}

variable "chart_version" {
  type = string
}

variable "control_namespace" {
  type = string
}

variable "destination_server" {
  type    = string
  default = "https://kubernetes.default.svc"
}

variable "argocd_project" {
  type    = string
  default = "default"
}

variable "loki_url" {
  type    = string
  default = ""
}