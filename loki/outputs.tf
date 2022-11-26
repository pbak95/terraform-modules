output "url" {
  value       = var.ingress.enabled ? "https://${var.ingress.host}" : "http://loki-read.${var.namespace}.svc.cluster.local:3100"
  description = "Loki HTTPS endpoint in case ingress is enabled. HTTP cluster local endpoint in case ingress is disabled."
}

output "auth" {
  value = {
    username = "loki"
    password = random_password.loki_password.result
  }
  sensitive = true
}
