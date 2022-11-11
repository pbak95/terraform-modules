terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    random = {
      source = "hashicorp/random"
    }
    argocd = {
      source = "oboukili/argocd"
    }
    htpasswd = {
      source = "loafoe/htpasswd"
    }
  }
}