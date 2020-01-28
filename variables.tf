variable "region" {
  description = "The GCP region to deploy the cluster into (e.g. us-central1)"
  type        = string
}

variable "zone" {
  description = "The GCP zone to deploy the cluster into (e.g. us-central1-a)"
  type        = string
}

variable "platform_name" {
  description = "The name of the cluster that is used for tagging resources"
  type        = string
}
