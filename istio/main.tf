resource "kubernetes_namespace" "istio-namespace" {
  metadata {
    annotations = {}

    labels = {}

    name = var.namespace
  }

  lifecycle {
    ignore_changes = [
      metadata[0].labels,
      metadata[0].annotations
    ]
  }
}

resource "kubernetes_manifest" "istio-manifests" {
  manifest = yamldecode(file("${path.module}/resources/generated-manifest.yaml"))
  depends_on = [kubernetes_namespace.istio-namespace]
}