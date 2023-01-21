resource "grafana_data_source" "data_source" {
  type                = var.type
  name                = var.name
  url                 = var.url
  basic_auth_enabled  = var.basic_auth_enabled
  basic_auth_username = var.credentials.username
  http_headers        = var.http_headers

  json_data {
    tls_skip_verify = var.tls_skip_verify
    manage_alerts   = var.type == "prometheus"
  }
  secure_json_data {
    basic_auth_password = var.credentials.password
  }
}