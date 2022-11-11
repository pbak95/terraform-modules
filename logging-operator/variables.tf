variable "namespace" {
  type = string
}

variable "chart_version" {
  type = string
}

variable "destination_server" {
  type = string
  default = "https://kubernetes.default.svc"
}

variable "argocd_project" {
  type = string
  default = "default"
}

variable "labels" {
  type    = map(string)
  default = {}
}
