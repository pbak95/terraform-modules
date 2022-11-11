resource "argocd_application" "logging-operator" {
  metadata {
    name      = "logging-operator-${var.environment}-${var.cluster}"
    namespace = var.namespace
    labels = {
      environment = var.environment
      cluster     = var.cluster
      namespace   = var.namespace
    }
  }
  wait = true
  timeouts {
    create = "20m"
    delete = "10m"
  }
  spec {
    project = var.argocd_project
    source {
      repo_url        = "https://kubernetes-charts.banzaicloud.com"
      chart           = "logging-operator"
      target_revision = var.chart_version
      helm {
        skip_crds    = true
        value_files  = ["values.yaml"]
        release_name = "logging-operator-${var.environment}"
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