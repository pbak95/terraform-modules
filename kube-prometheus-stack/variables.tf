variable "chart_version" {
  type = string
}

variable "namespace" {
  type = string
}

variable "argocd_project" {
  type = string
  default = "default"
}

variable "destination_server" {
  type = string
  default = "https://kubernetes.default.svc"
}

variable "labels" {
  type    = map(string)
  default = {}
}

variable "admin_credentials" {
  type = object({
    user     = string
    password = string
  })
  sensitive = true
}

variable "stack" {
  type = object({
    alertmanager = object({
      storage = object({
        size = string
      })
    })
    prometheus = object({
      storage = object({
        size = string
      })
    })
    grafana = object({
      enabled = bool
      storage = object({
        size = string
      })
    })
  })
  default = {
    alertmanager = {
      storage = {
        size = "1Gi"
      }
    }
    prometheus = {
      storage = {
        size = "5Gi"
      }
    }
    grafana = {
      enabled = true
      storage = {
        size = "1Gi"
      }
    }
  }
}

variable "servicemonitor_namespace_labels" {
  type    = map(string)
  default = {}
}
