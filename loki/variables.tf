variable "chart_version" {
  type = string
}

variable "destination_server" {
  type    = string
  default = "https://kubernetes.default.svc"
}

variable "labels" {
  type    = map(string)
  default = {}
}

variable "namespace" {
  type = string
}

variable "argocd_project" {
  type    = string
  default = "default"
}

variable "retention_enabled" {
  type    = bool
  default = true
}

variable "auth_enabled" {
  type        = bool
  default     = false
  description = "If true loki runs in multi-tenant mode and X-Scope-OrgID http header is required in communication with loki"
}

variable "ingress" {
  type = object({
    enabled            = bool
    ingress_class_name = string
    host               = string
    tls_secret_name    = string
  })
  default = {
    enabled            = false
    ingress_class_name = "nginx"
    host               = ""
    tls_secret_name    = ""
  }
}

variable "limits_config" {
  type = object({
    retention_period        = string
    ingestion_rate_mb       = string
    ingestion_burst_size_mb = string
  })
  description = "Loki limits configuration"
  default     = {
    retention_period        = "240h" # 10 days
    ingestion_rate_mb       = "6"
    ingestion_burst_size_mb = "8"
    //should match expected maximum logs size in single push requuest, current fluend config is 8MB
  }
}

variable "read" {
  type = object({
    replicas = number
  })
  description = "Configuration for the read"
  default     = {
    replicas = 2
  }
}

variable "write" {
  type = object({
    replicas = number
  })
  description = "Configuration for the write"
  default     = {
    replicas = 2
  }
}
