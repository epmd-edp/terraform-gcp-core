# terraform-gcp-core

The terraform-gcp-core repository contains code that installs GKE and all required resources.

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
- `dns.tf` - implements DNS zone and a wildcard for its creation;
- `firewall.tf` - implements firewall rules for health checks and ssh access to Kubernetes nodes creation. It requires a specific access to the service account;
- `gke.tf` - implements a Kubernetes cluster with two node-pools creation;
- `lb.tf` - implements HTTP/HTTPS load balancer pointing to the default node pool creation;
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

* Installation must be performed with Linux, WSL or GCP cloud shell machine; 
* GCP [service account](https://cloud.google.com/iam/docs/creating-managing-service-account-keys) is created with the following privileges:
    - Compute Viewer
    - Kubernetes Engine Admin
    - Kubernetes Engine Developer
    - Service Account Admin
    - Service Account User
    - Storage Object Admin
    - Storage Object Viewer  
* GCP service account JSON key is created and saved to the file on installation machine, e.g. "/path/to/key.json";
* **certificate.pem** and **private.pem** files are created for your domain. This supposed to be wildcard SSL certificate, which will be connected with a load balancer pointing to the cluster;
* [terraform](https://www.terraform.io/downloads.html) is installed;
* [kubectl](https://cloud.google.com/kubernetes-engine/docs/quickstart) is installed;

### Infrastructure Provision

To proceed with the infrastructure provision, make sure to do the following:
1. Set GCP service account credentials for terraform:
    ```bash
    export GOOGLE_APPLICATION_CREDENTIALS="/path/to/key.json"
    ```

2. If you plan to use a GCP bucket for terraform states, it is also necessary to define it in the `terraform_config.tf` file;

3. Update the `terraform.tfvars` file or define it via `export`:
    ```bash
    export TF_VAR_platform_name="edp-cluster"
    export TF_VAR_project_id="edp-project-id"
    export TF_VAR_certificate_path="/path/to/certificate.pem"
    export TF_VAR_private_key_path="/path/to/private.pem"
    ```
4. Run terraform:

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

_**NOTE**: The GKE deployment process can take at least 20 minutes._