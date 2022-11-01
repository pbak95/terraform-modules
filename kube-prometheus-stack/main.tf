resource "argocd_application" "kube_prometheus_stack" {
  metadata {
    name      = "kube-prometheus-stack-${var.cluster}"
    namespace = var.namespace
    labels    = var.labels
  }

  spec {
    project = var.argocd_project

    destination {
      server    = var.destination_server
      namespace = var.namespace
    }
    source {
      repo_url        = "https://prometheus-community.github.io/helm-charts"
      chart           = "prometheus-community/kube-prometheus-stack"
      target_revision = var.chart_version
      helm {
        skip_crds    = true
        release_name = "kube-prometheus-stack"
        parameter {
          name  = "grafana.adminUser"
          value = var.admin_credentials.user
        }

        parameter {
          name  = "grafana.adminPassword"
          value = var.admin_credentials.password
        }

        values = <<-EOT
          # Allows access to monitoring.coreos.com CRDs in all namespaces
          global:
            rbac:
              create:
                createAggregateClusterRoles: true
          alertmanager:
              storage:
                volumeClaimTemplate:
                  spec:
                    accessModes:
                    - ReadWriteOnce
                    resources:
                      requests:
                        storage: ${var.stack.alertmanager.storage.size}
          prometheus:
            prometheusSpec:
              storageSpec:
                volumeClaimTemplate:
                  spec:
                    accessModes:
                    - ReadWriteOnce
                    resources:
                      requests:
                        storage: ${var.stack.prometheus.storage.size}
              # Do not limit service monitors discovery to the ones produces by this Helm release
              serviceMonitorSelectorNilUsesHelmValues: false
              # Limit service monitors discovery to the current namespace
              %{if length(var.servicemonitor_namespace_labels) == 0}
              serviceMonitorNamespaceSelector: {}
              %{else}
              serviceMonitorNamespaceSelector:
                matchLabels:
                  %{for key, value in var.servicemonitor_namespace_labels}
                  ${key}: ${value}
                  %{endfor}
              %{endif}
          grafana:
            enabled: ${var.stack.grafana.enabled}
            persistence:
              type: pvc
              enabled: true
              size: ${var.stack.grafana.storage.size}
            dashboardProviders:
              dashboardproviders.yaml:
                apiVersion: 1
                providers:
                - name: 'default'
                  orgId: 1
                  folder: ''
                  type: file
                  disableDeletion: true
                  editable: false
                  options:
                    path: /var/lib/grafana/dashboards/default
          EOT
      }
    }

    sync_policy {
      automated = {
        prune       = true
        self_heal   = true
        allow_empty = true
      }

      sync_options = ["Validate=false"]
      retry {
        limit   = "5"
        backoff = {
          duration     = "30s"
          max_duration = "10m"
          factor       = "2"
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [metadata]
  }
}
