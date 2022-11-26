resource "argocd_application" "logging-operator-resource" {
  metadata {
    name      = "logging"
    namespace = var.namespace
    labels    = var.labels
  }
  wait = true
  timeouts {
    create = "20m"
    delete = "10m"
  }
  spec {
    project = var.argocd_project
    source {
      repo_url  = "https://github.com/banzaicloud/logging-operator.git"
      repo_path = "charts/logging-operator-logging"
      tag       = "chart/logging-operator-logging/${var.chart_version}"
      helm {
        value_files  = ["values.yaml"]
        release_name = "logging"

        parameter {
          name  = "controlNamespace"
          value = var.control_namespace
        }
        parameter {
          name  = "tls.enabled"
          value = "false"
        }
        parameter {
          name  = "fluentbit.tolerations[0].key"
          value = "node-role.kubernetes.io/master"
        }
        parameter {
          name  = "fluentbit.tolerations[0].effect"
          value = "NoSchedule"
        }
        parameter {
          name  = "eventTailer.name"
          value = "kubernetes-events"
        }
        parameter {
          name  = "hostTailer.systemdTailers[0].name"
          value = "systemd-events"
        }
        parameter {
          name  = "hostTailer.systemdTailers[0].path"
          value = "/run/log/journal"
        }

        parameter {
          name  = "clusterFlows[0].name"
          value = "all-pods"
        }
        parameter {
          name  = "clusterFlows[0].spec.globalOutputRefs[0]"
          value = "loki-all-pods"
        }
        parameter {
          name  = "clusterFlows[0].spec.match[1].select.namespaces[0]"
          value = ""
        }
        parameter {
          name  = "clusterOutputs[0].name"
          value = "loki-all-pods"
        }
        #TODO: to inject full namespace name and not hardcode some part of the namespace platform-
        parameter {
          name  = "clusterOutputs[0].spec.loki.url"
          value = var.loki_url
        }
        parameter {
          name  = "clusterOutputs[0].spec.loki.configure_kubernetes_labels"
          value = "true"
        }
        parameter {
          name  = "clusterOutputs[0].spec.loki.buffer.timekey"
          value = "1m"
        }
        parameter {
          name  = "clusterOutputs[0].spec.loki.buffer.tags"
          value = "time"
        }
        parameter {
          name  = "clusterOutputs[0].spec.loki.buffer.retry_forever"
          value = false
        }
        parameter {
          name  = "clusterOutputs[0].spec.loki.buffer.retry_max_times"
          value = "30"
        }
        parameter {
          name  = "clusterOutputs[0].spec.loki.buffer.timekey_wait"
          value = "30s"
        }
        parameter {
          name  = "clusterOutputs[0].spec.loki.buffer.timekey_use_utc"
          value = "true"
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
      sync_options = ["Validate=false", "createCustomResource=false"]
      retry {
        limit   = "5"
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
