locals {
  manifests_path = "${path.module}/resources/generated-manifest.yaml"
}

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
  manifest = yamldecode(file(local.manifests_path))
  depends_on = [kubernetes_namespace.istio-namespace]
}