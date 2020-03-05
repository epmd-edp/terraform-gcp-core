# terraform-gcp-core

The terraform-gcp-core installs GKE and all required resources.

Each environment can be customized using different infrastructure building blocks with different versions.

## Repository Structure

Become familiar with the main structure of the repository:
```bash
./
├── address.tf
├── dns.tf
├── firewall.tf
├── gke.tf
├── lb.tf
├── main.tf
├── network.tf
├── README.md
├── terraform.tfvars
├── terraform_config.tf
├── terraform_providers.tf
└── variables.tf
```

- `address.tf` - implements static public IP address creation;
- `dns.tf` - implements DNS zone and a wildcard for it creation;
- `firewall.tf` - implements firewall rules for health checks and ssh access to Kubernetes nodes creation. It requires specific access for the service account;
- `gke.tf` - implements a Kubernetes cluster with two node-pools creation;
- `lb.tf` - implements HTTP/HTTPS load balancer pointing to default node pool creation;
- `network.tf` - implements a new VPC and a Cloud NAT creation;
- `variables.tf` - contains all variables that should be defined inside environment. It is a common practice not to define them with the default values, but it is explicitly required for user definition;
- `terraform_providers.tf` - file with terraform providers and their pinning versions. This file allows to control terraform provider versions and track that all developers are on the same version when applying infrastructure changes;
- `terraform_config.tf` - defines the remote state working procedure, the location where to store the remote state and lock flag. This file ensures that only one developer can manipulate with infrastructure from any endpoint at any time;
- `README.md` - contains some specific documentation;
- `main.tf` - defines which terraform modules to use and what parameters to pass;
---

## Installation

### Prerequisites

In order to use the terraform-gcp-core component, pay attention to the following prerequisites:

* GCP profile is configured;
* [certificate.pem]() and [private.pem]() files for your domain are created;
* [gcloud](https://cloud.google.com/sdk/install) is installed;
* [terraform](https://www.terraform.io/downloads.html) is installed;
* [kubectl](https://cloud.google.com/kubernetes-engine/docs/quickstart) is installed;
* [service account](https://cloud.google.com/iam/docs/creating-managing-service-account-keys) is created and there is the the service account key.

### Environment preparation

1. Activate the service account
```bash
gcloud auth activate-service-account --key-file=/path/to/key.json
```

2. Configure `gcloud` for the particular project
```bash
gcloud config set project edp-project-id
```
3. If you plan to use a GCP bucket for terraform states, it is necessary to define it in the `terraform_config.tg` and export the variable for access to the bucket
```bash
export GOOGLE_APPLICATION_CREDENTIALS="/path/to/key.json"
```

4. Update the `terraform.tfvars` file or define it via `export`
```bash
export TF_VAR_platform_name="edp-cluster"
export TF_VAR_project_id="edp-project-id"
export TF_VAR_certificate_path="/path/to/certificate.pem"
export TF_VAR_private_key_path="/path/to/private.pem"
```
5. Run terraform

* Initialize remote state and download modules:
```bash
terraform init
```
* Check the resource creation plan:
```bash
terraform plan
```
* Review the list of resources to create and deploy infrastructure:
```bash
terraform apply
```

_**NOTE**: The GKE deployment process can take about 20 minutes._
