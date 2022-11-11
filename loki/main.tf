resource "argocd_application" "loki" {
  metadata {
    name      = "loki"
    namespace = var.namespace
    labels = var.labels
  }

  wait = true
  timeouts {
    create = "20m"
    delete = "10m"
  }

  spec {
    project = var.argocd_project

    source {
      repo_url        = "https://grafana.github.io/helm-charts"
      chart           = "loki"
      target_revision = var.chart_version
      helm {
        value_files  = ["values.yaml"]
        release_name = "loki"

        parameter {
          name  = "persistence.enabled"
          value = "true"
        }

        parameter {
          name  = "config.server.grpc_server_max_recv_msg_size"
          value = "8388608"
        }

        parameter {
          name  = "persistence.size"
          value = "5Gi"
        }
        parameter {
          name  = "persistence.accessMode[0]"
          value = "ReadWriteOnce"
        }

        parameter {
          name  = "config.auth_enabled"
          value = var.auth_enabled
        }

        parameter {
          name  = "config.compactor.retention_enabled"
          value = var.retention_enabled
        }
        parameter {
          name  = "config.limits_config.retention_period"
          value = var.limits_config.retention_period
        }
        parameter {
          name  = "config.limits_config.ingestion_rate_mb"
          value = var.limits_config.ingestion_rate_mb
        }
        parameter {
          name  = "config.limits_config.ingestion_burst_size_mb"
          value = var.limits_config.ingestion_burst_size_mb
        }
        parameter {
          name  = "ingress.enabled"
          value = var.ingress.enabled
        }
        parameter {
          name  = "ingress.ingressClassName"
          value = var.ingress.ingress_class_name
        }
        parameter {
          name  = "ingress.hosts[0].host"
          value = var.ingress.host
        }
        parameter {
          name  = "ingress.hosts[0].paths[0]"
          value = "/"
        }
        parameter {
          name  = "ingress.tls[0].secretName"
          value = var.ingress.tls_secret_name
        }
        parameter {
          name  = "ingress.tls[0].hosts[0]"
          value = var.ingress.host
        }
        parameter {
          name  = "ingress.annotations.nginx\\.ingress\\.kubernetes\\.io\\/auth\\-type"
          value = "basic"
        }
        parameter {
          name  = "ingress.annotations.nginx\\.ingress\\.kubernetes\\.io\\/auth\\-secret"
          value = "loki-auth"
        }
        parameter {
          name  = "ingress.annotations.nginx\\.ingress\\.kubernetes\\.io\\/auth\\-secret\\-type"
          value = "auth-map"
        }
      }
    }

    destination {
      server    = var.destination_server
      namespace = var.namespace
    }

    sync_policy {
      automated = {
        prune       = true
        self_heal   = true
        allow_empty = true
      }

      sync_options = ["Validate=false"]
      retry {
        limit = "5"
        backoff = {
          duration     = "30s"
          max_duration = "2m"
          factor       = "2"
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [metadata]
  }
}

resource "random_password" "loki_password" {
  length  = 20
  special = false

  count = var.ingress.enabled ? 1 : 0
}

resource "htpasswd_password" "hash" {
  password = random_password.loki_password.result

  count = var.ingress.enabled ? 1 : 0
}

resource "kubernetes_secret" "loki_auth" {
  metadata {
    name      = "loki-auth"
    namespace = var.namespace
  }

  data = {
    loki = htpasswd_password.hash.sha512 //TODO inject from secret store when installed
  }

  lifecycle {
    ignore_changes = [metadata]
  }

  count = var.ingress.enabled ? 1 : 0
}

