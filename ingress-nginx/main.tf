resource "helm_release" "ingress-nginx" {
  name       = "ingress-nginx"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx-ingress-controller"
  version    = var.chart_version

  namespace = "kube-system"


  #TODO Remove image tag parameter after the bug is solved:  https://github.com/bitnami/charts/issues/12028
  set {
    name  = "image.tag" 
    value = "1.3.0-debian-11-r9"
  }

  set {
    name  = "replicaCount"
    value = "2"
  }

  set {
    name  = "affinity"
    value = <<-EOT
    podAntiAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
      - labelSelector:
          matchExpressions:
          - key: app.kubernetes.io/name
            operator: In
            values:
            - {{ .Chart.Name }}
          - key: app.kubernetes.io/instance
            operator: In
            values:
            - {{ .Release.Name }}
          - key: app.kubernetes.io/component
            operator: In
            values:
            - controller
          - key: helm.sh/chart
            operator: In
            values:
            - {{ .Chart.Name }}-{{ .Chart.Version }}
        topologyKey: "kubernetes.io/hostname"
    EOT
  }


  set {
    name  = "ingressClassResource.default"
    value = "true"
  }

  set {
    name  = "hostNetwork"
    value = "false"
  }

  set {
    name  = "daemonset.useHostPort"
    value = "true"
  }

  set {
    name  = "metrics.enabled"
    value = "true"
  }

  set {
    name  = "metrics.serviceMonitor.enabled"
    value = "false" //TODO detect if prometheus is installed and set this value
  }

  set {
    name  = "metrics.serviceMonitor.namespace"
    value = var.monitoring_namespace
  }


  set {
    name  = "config.use-forwarded-headers"
    value = "true"
  }
}
