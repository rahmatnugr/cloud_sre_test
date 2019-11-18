# Part `data-stores`

This directory contains terraform code for provisioning part `data-stores` of Chatapp AWS Infrastructure.

## Dependencies

This project part depends on remote state bucket of project part:

- `core-network`

So, make sure part `core-network` successfully provisioned and state stored in backend.

## Specification

This is specification of infrastructure that will be provisioned with this part.

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

---

### Subnetting

Module Path

[../../modules/networking/subnet](/solutions/terraform/modules/networking/subnet)

#### Private subnet for Elasticache Redis

Subnet CIDR

| env  | value AZ1     | value AZ2     | value AZ3     |
| ---- | ------------- | ------------- | ------------- |
| dev  | "10.3.5.0/24" | "10.3.6.0/24" | "10.3.7.0/24" |
| stag | "10.2.5.0/24" | "10.2.6.0/24" | "10.2.7.0/24" |
| prod | "10.1.5.0/24" | "10.1.6.0/24" | "10.1.7.0/24" |

#### Private subnet for Aurora

Subnet CIDR

| env  | value AZ1     | value AZ2     | value AZ3      |
| ---- | ------------- | ------------- | -------------- |
| dev  | "10.3.8.0/24" | "10.3.9.0/24" | "10.3.10.0/24" |
| stag | "10.2.8.0/24" | "10.2.9.0/24" | "10.2.10.0/24" |
| prod | "10.1.8.0/24" | "10.1.9.0/24" | "10.1.10.0/24" |

---

### Routing

Using resource `aws_route_table_association`

Associate private subnet for redis and aurora to route table for private subnet

---

### Security Group

Module Path

[../../modules/networking/security-group](/solutions/terraform/modules/networking/security-group)

#### SG for Elasticache Redis

Ingress

| from_port | to_port | protocol | source           |
| --------- | ------- | -------- | ---------------- |
| 6379      | 6379    | tcp      | SG ID of Fargate |

Egress

| from_port | to_port | protocol | source    |
| --------- | ------- | -------- | --------- |
| 0         | 0       | -1 (all) | 0.0.0.0/0 |

#### SG for Aurora

Ingress

| from_port | to_port | protocol | source           |
| --------- | ------- | -------- | ---------------- |
| 3306      | 3306    | tcp      | SG ID of Fargate |

Egress

| from_port | to_port | protocol | source    |
| --------- | ------- | -------- | --------- |
| 0         | 0       | -1 (all) | 0.0.0.0/0 |

---

### Elasticache Redis Cluster

Module Path

[../../modules/data-stores/elasticache](/solutions/terraform/modules/data-stores/elasticache)

Create Elasticache Redis Cluster with provisioned Subnets and Security Groups across all 3 AZ.

---

### Aurora Cluster

Module Path

[../../modules/data-stores/aurora](/solutions/terraform/modules/data-stores/aurora)

Create Aurora Cluster with provisioned Subnets and Security Groups across all 3 AZ.

When creating Aurora cluster, atabase name and database credentials (master username and password) should be configured in file `data-stores.tfvars` (copying from `data-stores.tfvars.example`) and use those file to execute `terraform plan`

> Security Recommendation: Use proper and secure storage for storing credentials, example: Vault

---

### S3 Bucket (for static web hosting)

Module Path

[../../modules/data-stores/s3-www](/solutions/terraform/modules/data-stores/s3-www)

Create S3 Bucket with website static hosting featured activated, with public-read ACL.

---

## Quick command

```sh
cp data-stores.tfvars.example data-stores.tfvars

terraform init -backend-config=../config/s3-backend.conf

terraform workspace new dev

terraform plan -out=data-stores.tfplan -var-file=data-stores.tfvars

terraform apply data-stores.tfplan

terraform destroy -var-file=data-stores.tfvars
```
