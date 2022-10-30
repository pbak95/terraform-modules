locals {
  secretName = replace("${var.cluster_domain}", ".", "-")
}

resource "kubernetes_manifest" "selfsigned-issuer" {
  manifest = yamldecode(<<-EOF
    apiVersion: cert-manager.io/v1
    kind: Issuer
    metadata:
     name: root-selfsigned-issuer
     namespace: ${var.namespace}
    spec:
     selfSigned: {}
    EOF
  )
}

resource "kubernetes_manifest" "ca" {
  manifest = yamldecode(<<-EOF
    apiVersion: cert-manager.io/v1
    kind: Certificate
    metadata:
     name: ${var.environment}-ca
     namespace: ${var.namespace}
    spec:
     # name of the tls secret to store
     # the generated certificate/key pair
     secretName: ${var.environment}-ca
     isCA: true
     issuerRef:
       name: root-selfsigned-issuer
       kind: Issuer
     commonName: ${var.base_domain}
     duration: 87600h #10y
     dnsNames:
     # one or more fully-qualified domain name
     # can be defined here
     - ${var.cluster_domain}
    EOF
  )
}

resource "kubernetes_manifest" "cluster-issuer" {
  manifest = yamldecode(<<-EOF
    apiVersion: cert-manager.io/v1
    kind: ClusterIssuer
    metadata:
     name: ${var.environment}-selfsigned-issuer
    spec:
     ca:
       secretName: ${var.environment}-ca
    EOF
  )
}

resource "kubernetes_manifest" "namespace-wildcard" {
  manifest = yamldecode(<<-EOF
    apiVersion: cert-manager.io/v1
    kind: Certificate
    metadata:
     name: ${var.namespace}-wildcard
     namespace: ${var.namespace}
    spec:
     # name of the tls secret to store
     # the generated certificate/key pair
     secretName: ${local.secretName}
     issuerRef:
       # Issuer Name
       name: ${var.environment}-selfsigned-issuer
       # The default value is Issuer (i.e.
       # a locally namespaced Issuer)
       kind: ClusterIssuer
     commonName: "*.${var.base_domain}"
     dnsNames:
      # one or more fully-qualified domain names
      # can be defined here
     - "*.${var.base_domain}"
    EOF
  )
}