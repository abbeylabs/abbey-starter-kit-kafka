variable "bootstrap_servers" {
  type = list(string)
  sensitive = true
  description = "Addresses of bootstrap servers"
}