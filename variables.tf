variable "region" {
  description = "The GCP region to deploy the cluster into (e.g. us-central1)"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The GCP zone to deploy the cluster into (e.g. us-central1-a)"
  type        = string
  default     = "us-central1-a"
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

variable "private_key_path" {
  description = "Path to the private key file"
  type        = string
}

variable "certificate_path" {
  description = "Path to the public key certificate file"
  type        = string
}

variable "kubernetes_version" {
  description = "The minimum version of the master GKE"
  type        = string
  default     = "1.15.8-gke.3"
}

variable "min_node_count" {
  description = "The minimum number of nodes in the workload node pool"
  type        = number
  default     = 1
}

variable "max_node_count" {
  description = "The maximum number of nodes in the workload node pool"
  type        = number
  default     = 1
}

variable "is_preemptible" {
  description = "Are nodes preemptible or not in the workload node pool"
  type        = bool
  default     = true
}

variable "machine_type" {
  description = "The type of nodes in the workload node pool"
  type        = string
  default     = "n1-standard-1"
}

