# Part `app-cluster`

This directory contains terraform code for provisioning part `app-cluster` of Chatapp AWS Infrastructure.

## Dependencies

This project part depends on remote state bucket of project part:

- `core-network`
- `data-stores`

So, make sure those parts successfully provisioned and the state stored in backend.

## Specification

This is specification of infrastructure that will be provisioned with this part.

| No. | Service/Resource                 |
| --- | -------------------------------- |
| 1   | Elastic Container Registry (ECR) |
| 2   | ECS Fargate Cluster              |
| 3   | ECS Autoscaling                  |

---

#### Elastic Container Registry

Module Path

[../../modules/compute/ecr](/solutions/terraform/compute/ecr)

Create container registry with name `${workspace_name}_chatapp_backend` for storing container image of backend app

---

#### ECS Fargate Cluster

Module Path

[../../modules/compute/ecs-fargate](/solutions/terraform/modules/compute/ecs-fargate)

Create ECS Fargate Cluster, and also create Task and Service for running backend app, with 512 cpu unit and 1024 memory unit resource. Desired task count is 3, that means backend app will be replicated 3 times and traffic will be spread by ALB. Backend app will be listening on port `80`. Associated with previously provisioned Subnets and Security Groups across all 3 AZ.

> Note: On this ECS Fargate Task, assuming backend app accepting some environment variable related to app port and app database credentials to be injected. `app-cluster.tfvars` must be copied from `app-cluster.tfvars.example`. Configure that file with mysql username and password and use that file when executing `terraform plan` .

> Security Recommendation: Use proper and secure storage for storing credentials, example: Vault

> Note: on the first time provisioning ECS cluster, the resource can't be tagged until we opt in new id system from AWS Console. Read [this](https://github.com/terraform-providers/terraform-provider-aws/issues/7373)

---

### ECS Autoscaling

Module Path

[../../modules/compute/ecs-scaling](/solutions/terraform/modules/compute/ecs-scaling)

ECS Autoscaling will be scale ECS Fargate task of backend app in and out by using Cloudwatch CPU Metrics and Alarm. The scale out policy will be triggered when CPU usage reaching 70% upper threshold and scale in policy will be triggered when CPU usage reaching 10% lower threshold. Minimum capacity of task is 3 and maximum is 6.

## Quick command

```sh
cp app-cluster.tfvars.example app-cluster.tfvars

terraform init -backend-config=../config/s3-backend.conf

terraform workspace new dev

terraform plan -out=app-cluster.tfplan -var-file=app-cluster.tfvars

terraform apply app-cluster.tfplan

terraform destroy -var-file=app-cluster.tfvars
```
