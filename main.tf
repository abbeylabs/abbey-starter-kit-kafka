terraform {
  backend "http" {
    address        = "http://localhost:3000/terraform-http-backend"
    lock_address   = "http://localhost:3000/terraform-http-backend/lock"
    unlock_address = "http://localhost:3000/terraform-http-backend/unlock"
    lock_method    = "POST"
    unlock_method  = "POST"
  }

  required_providers {
    abbey = {
      source = "abbeylabs/abbey"
      version = "0.1.4"
    }

    kafka = {
      source = "Mongey/kafka"
      version = "0.5.3"
    }
  }
}

provider "abbey" {
  # Configuration options
}

provider "kafka" {
  bootstrap_servers = var.bootstrap_servers
  ca_cert      = file("../secrets/ca.crt")
  client_cert  = file("../secrets/terraform-cert.pem")
  client_key   = file("../secrets/terraform.pem")
  skip_tls_verify   = true
}

resource "abbey_grant_kit" "kafka_pii_acl" {
  name = "Kafka PII ACL"
  description = "Kafka PII ACL"

  workflow = {
    steps = [
      {
        reviewers = {
          one_of = ["replace-me@example.com"]
        }
      }
    ]
  }

  policies = {
    grant_if = [
      {
        query = <<-EOT
          package main

          import data.abbey.functions

          allow[msg] {
            true; functions.expire_after("24h")
            msg := "granting access for 24 hours"
          }
        EOT
      }
    ]
  }

  output = {
    location = "github://organization/repo/access.tf"
    append = <<-EOT
      resource "kafka_acl" "principal_{{ .data.system.abbey.secondary_identities.kafka.principal }}" {
        resource_name = "syslog"
        resource_type = "Topic"
        acl_principal = "User:{{ .data.system.abbey.secondary_identities.kafka.principal }}"
        acl_host = "*"
        acl_operation = "Read"
        acl_permission_type = "Allow"
      }
    EOT
  }
}

resource "abbey_identity" "user_1" {
  name = "replace-me"

  linked = jsonencode({
    abbey = [
      {
        type  = "AuthId"
        value = "replace-me@example.com"
      }
    ]

    kafka = [
      {
        principal = "replaceme"
      }
    ]
  })
}