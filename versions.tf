terraform {
  required_providers {
    abbey = {
      source = "abbeylabs/abbey"
      version = "~> 0.2.6"
    }

    kafka = {
      source = "Mongey/kafka"
      version = "~> 0.5.3"
    }
  }
}
