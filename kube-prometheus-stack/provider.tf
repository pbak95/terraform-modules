terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    argocd = {
      source  = "oboukili/argocd"
    }
  }
}
