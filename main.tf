locals {
  account_name = ""
  repo_name = ""

  project_path = "github://${local.account_name}/${local.repo_name}"
  policies_path = "${local.project_path}/policies"
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

  policies = [
    { bundle = local.policies_path }
  ]

  output = {
    location = "${local.project_path}/access.tf"
    append = <<-EOT
      resource "kafka_acl" "principal_{{ .user.kafka.principal }}" {
        resource_name = "syslog"
        resource_type = "Topic"
        acl_principal = "User:{{ .user.kafka.principal }}"
        acl_host = "*"
        acl_operation = "Read"
        acl_permission_type = "Allow"
      }
    EOT
  }
}
