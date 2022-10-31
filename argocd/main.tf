resource "null_resource" "argocd_password_bcrypt" {
  # see https://github.com/hashicorp/terraform-provider-random/issues/102 for details
  triggers = {
    source = var.admin_password
    value  = bcrypt(var.admin_password)
  }

  lifecycle {
    ignore_changes = [triggers["value"]]
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.chart_version
  skip_crds  = false

  namespace = var.namespace

  set {
    name  = "notifications.enabled"
    value = "false"
  }

  set {
    name  = "applicationSet.enabled"
    value = "false"
  }

  //TODO change after ingress module is developed
#  set {
#    name  = "server.ingress.enabled"
#    value = "false"
#  }
#  set {
#    name  = "server.ingress.hosts[0]"
#    value = "argocd.${var.base_domain}"
#  }
#  set {
#    name  = "server.ingress.paths[0]"
#    value = "/"
#  }
#  set {
#    name  = "server.ingress.tls[0].hosts[0]"
#    value = "argocd.${var.base_domain}"
#  }
#  set_sensitive {
#    name  = "server.ingress.tls[0].secretName"
#    value = var.tls_secret_name
#  }
#  set {
#    name  = "server.config.url"
#    value = "https://argocd.${var.base_domain}/"
#  }
  set_sensitive {
    name  = "configs.secret.argocdServerAdminPassword"
    value = null_resource.argocd_password_bcrypt.triggers["value"]
  }
  set {
    name  = "configs.secret.argocdServerAdminPasswordMtime"
    value = "2021-05-20T15:04:05Z"
  }
#  set {
#    name  = "server.extraArgs[0]"
#    value = "--insecure"
#  }
  set {
    name  = "global.image.repository"
    value = "argoproj/argocd"
  }
  set {
    name  = "dex.enabled"
    value = "false"
  }
}
