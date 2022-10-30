resource "helm_release" "cert-manager" {
  name             = "cert-manager-${var.environment}"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "cert-manager"
  version          = var.chart_version
  create_namespace = true

  namespace = var.namespace

  # terraform might show external changes due to https://github.com/hashicorp/terraform-provider-helm/issues/749

  set {
    name  = "installCRDs"
    value = true
  }
  set {
    name  = "webhook.serviceAnnotations"
    value = "cert-manager.io/inject-ca-from: ${var.namespace}/${var.environment}-ca"
  }
  set {
    name  = "prometheus.enabled"
    value = "false" //TODO detect if prometheus is installed and set this value
  }
  set {
    name  = "prometheus.servicemonitor.enabled"
    value = "false" //TODO detect if prometheus is installed and set this value
  }
}
