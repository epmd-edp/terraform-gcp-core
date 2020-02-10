variable "region" {
  description = "The GCP region to deploy the cluster into (e.g. us-central1)"
  type        = string
  default     = "us-central1"
}

variable "zones" {
  description = "The GCP zone to deploy the cluster into (e.g. us-central1-a)"
  type        = list(string)
  default     = ["us-central1-a"]
}

variable "platform_name" {
  description = "The name of the cluster that is used for tagging resources"
  type        = string
}

variable "project_id" {
  description = "The project ID to host the cluster in"
  type        = string
}

variable "domain" {
  description = "Zone domain."
  default     = "edp.epam.com."
}
