resource "helm_release" "crossplane" {
  name             = "crossplane-${var.environment}"
  repository       = "https://charts.crossplane.io/stable"
  chart            = "crossplane"
  version          = var.chart_version
  create_namespace = true

  namespace = var.namespace
}
