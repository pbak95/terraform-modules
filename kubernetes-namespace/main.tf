resource "kubernetes_namespace" "namespace" {
  metadata {
    annotations = var.annotations

    labels = var.labels

    name = var.namespace
  }

  lifecycle {
    ignore_changes = [
      metadata[0].labels,
      metadata[0].annotations
    ]
  }
}
