# Terraform Project Directory for Solution 2

This directory holds terraform code for provisioning AWS cloud infrastructure required for running Chatapp with Solution 2.

## Diagram

![](/solutions/images/HOOQ_cloud_sre_test-Solution_2.png)

---

## Project structure

From the diagram, breaked into several part:

- [`core-network`](/solutions/terraform/project/core-network)
- [`data-stores`](/solutions/terraform/project/data-stores)
- [`app-cluster`](/solutions/terraform/project/app-cluster)
- [`distribution`](/solutions/terraform/project/distribution)

This table showing AWS Service that will need to provisioned with terraform, according to each part above:

### Part `core-network`

| No. | Service/Resource                |
| --- | ------------------------------- |
| 1   | VPC                             |
| 2   | NAT Gateway                     |
| 3   | Internet Gateway                |
| 4   | Public Subnet                   |
| 5   | Private Subnet (for Fargate)    |
| 6   | Security Group (for Fargate)    |
| 7   | Route table and association     |
| 8   | Application Load Balancer (ALB) |
| 9   | Security Group (for ALB)        |

### Part `data-stores`

| No. | Service/Resource                                                |
| --- | --------------------------------------------------------------- |
| 1   | Private subnet (for Elasticache Redis)                          |
| 2   | Private subnet (for Aurora)                                     |
| 3   | Route table and association (for Redis & Aurora Private subnet) |
| 4   | Security Group (for Elasticache Redis)                          |
| 5   | Security Group (for Aurora)                                     |
| 6   | Elasticache Redis Cluster                                       |
| 7   | Aurora Cluster                                                  |
| 8   | S3 Bucket (for static web hosting)                              |

### Part `app-cluster`

| No. | Service/Resource                 |
| --- | -------------------------------- |
| 1   | Elastic Container Registry (ECR) |
| 2   | ECS Fargate Cluster              |
| 3   | ECS Autoscaling                  |

### Part `distribution`

| No. | Service/Resource |
| --- | ---------------- |
| 1   | Cloudfront CDN   |
| 2   | Route 53         |

All of these project part will be importing modules from [`modules`](/solutions/terraform/project/modules) directory.

Also there is [`config`](/solutions/terraform/project/config) directory for storing remote state backend config (S3).

---

## Requirements

- Terraform

  This terraform project using version `0.12.13`. All of terraform modules are configured to use terraform version minimum `0.12.x` and below `0.13.x`.

- AWS Credentials

  AWS Credentials (access id and secret access key) stored in credentials file (`~/.aws/credentials`) with eligible role for running terraform task

- S3 Bucket (remote state backend)

  This project using S3 bucket as remote state backend. Name of bucket should be stored in `config/s3-backend.conf` file. S3 bucket versioning feature should be active (optional).

---

## Initialization

1. Copy `config/s3-backend.conf.sample` to `config/s3-backend.conf`
2. Configure all remote state s3 backend configuration (bucket, encryption, region, etc.) to `config/s3-backend.conf`
3. Make sure AWS credentials for accessing those s3 bucket are configured in credentials file (`~/.aws/credentials`)
4. Run `terraform init -backend-config=../config/s3-backend.conf` inside all subdirectory, except directory `config`, for initializing backend, provider, and modules for each part
5. After terraform initialization, change workspace to supported workspace described [here](#working-with-workspace)
6. Finally, you can continue to run `terraform plan` and `terraform apply` to each part of this project

> Attention: `terraform plan` and `terraform apply` command must be executed inside project parts sequentially in this order: `core-network` -> `data-stores` -> `app-cluster` -> `distribution`

---

## Working with `workspace`

This project heavily use workspace (for tagging resource, saving state, separating environment of project, etc).

Supported workspace:

- `dev` for development environment
- `stag` for staging environment
- `prod` for production environment

Example workspace initialization (execute from each part/subdirectory):

```bash
env=dev
terraform workspace new $env
```

Changing workspace:

```bash
env=stag
terraform workspace select $env
```

Listing workspace:

```bash
terraform workspace list
```

Delete workspace:

```bash
env=dev
terraform workspace delete $env
```
