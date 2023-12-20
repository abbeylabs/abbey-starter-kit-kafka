provider "abbey" {
  bearer_auth = var.abbey_token
}

provider "kafka" {
  bootstrap_servers = var.bootstrap_servers
  ca_cert      = file("../secrets/ca.crt")
  client_cert  = file("../secrets/terraform-cert.pem")
  client_key   = file("../secrets/terraform.pem")
  skip_tls_verify   = true
}
