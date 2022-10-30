locals {
  crds_path = "${path.module}/resources/crds/*.yaml"
  manifests_path = "${path.module}/resources/*.yaml"
}

resource "kubernetes_namespace" "istio_namespace" {
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

resource "kubernetes_manifest" "istio_crds" {
  for_each = fileset(path.module, local.crds_path)
  manifest = yamldecode(file("${path.module}/resources/crds/${each.value}"))
  depends_on = [kubernetes_namespace.istio_namespace]
}

resource "kubernetes_manifest" "istio_manifests" {
  for_each = fileset(path.module, local.manifests_path)
  manifest = yamldecode(file("${path.module}/resources/${each.value}"))
  depends_on = [kubernetes_manifest.istio_crds]
}