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

resource "null_resource" "istio" {
  depends_on = [kubernetes_namespace.istio_namespace]

  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    istio_system_namespace = kubernetes_namespace.istio_namespace.uid
  }

  provisioner "local-exec" {
    command = "./resources/istioctl install --set profile=ambient -i ${var.namespace}"
  }
}