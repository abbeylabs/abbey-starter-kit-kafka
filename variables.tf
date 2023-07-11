variable "abbey_token" {
  type = string
  sensitive = true
  description = "Abbey API Token"
}

variable "bootstrap_servers" {
  type = list(string)
  sensitive = true
  description = "Addresses of bootstrap servers"
}