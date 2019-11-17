# Part `core-network`

This directory contains terraform code for provisioning part `core-network` of Chatapp AWS Infrastructure.

## Specification

This is specification of infrastructure that will be provisioned with this part.

| No. | Service/Resource                   |
| --- | ---------------------------------- |
| 1   | VPC                                |
| 2   | NAT Gateway                        |
| 3   | Internet Gateway                   |
| 4   | Public Subnet (for NAT GW and ALB) |
| 5   | Private Subnet (for Fargate)       |
| 6   | Security Group (for Fargate)       |
| 7   | Route table and association        |
| 8   | Application Load Balancer (ALB)    |
| 9   | Security Group (for ALB)           |

---

### VPC

Module Path

[../../modules/networking/vpc](/solutions/terraform/modules/networking/vpc)

CIDR

| env  | value         |
| ---- | ------------- |
| dev  | "10.3.0.0/16" |
| stag | "10.2.0.0/16" |
| prod | "10.1.0.0/16" |

---

### Subnetting

Module Path

[../../modules/networking/subnet](/solutions/terraform/modules/networking/subnet)

#### Public Subnet (for NAT Gateway)

Subnet CIDR

| env  | value           |
| ---- | --------------- |
| dev  | "10.3.255.0/28" |
| stag | "10.2.255.0/28" |
| prod | "10.1.255.0/28" |

#### Public Subnet (for ALB)

Subnet CIDR

| env  | value AZ1     | value AZ2      | value AZ3      |
| ---- | ------------- | -------------- | -------------- |
| dev  | "10.3.1.0/28" | "10.3.1.16/28" | "10.3.1.32/28" |
| stag | "10.2.1.0/28" | "10.2.1.16/28" | "10.2.1.32/28" |
| prod | "10.1.1.0/28" | "10.1.1.16/28" | "10.1.1.32/28" |

#### Private Subnet (for Fargate)

Subnet CIDR

| env  | value AZ1     | value AZ2     | value AZ3     |
| ---- | ------------- | ------------- | ------------- |
| dev  | "10.3.2.0/24" | "10.3.3.0/24" | "10.3.4.0/24" |
| stag | "10.2.2.0/24" | "10.2.3.0/24" | "10.2.4.0/24" |
| prod | "10.1.2.0/24" | "10.1.3.0/24" | "10.1.4.0/24" |

---

### Gateway

Module Path

[../../modules/networking/gateway](/solutions/terraform/modules/networking/gateway)

#### Internet Gateway

Create 1 internet gateway for handling ingress traffic from internet to VPC

#### NAT Gateway

Create 1 NAT gateway for handling eggress traffic from private subnet to internet

---

### Application Load Balancer

Module Path

[../../modules/networking/alb](/solutions/terraform/modules/networking/alb)

Using 3 Security Group with 3 Subnet across 3 AZ. With session stickiness (for websocket purposes)

---

### Security Group

Module Path

[../../modules/networking/security-group](/solutions/terraform/modules/networking/security-group)

#### SG for Fargate

Ingress

| from_port | to_port | protocol | source       |
| --------- | ------- | -------- | ------------ |
| 80        | 80      | tcp      | SG ID of ALB |

Egress

| from_port | to_port | protocol | source    |
| --------- | ------- | -------- | --------- |
| 0         | 0       | -1 (all) | 0.0.0.0/0 |

#### SG for ALB

Ingress

| from_port | to_port | protocol | source    |
| --------- | ------- | -------- | --------- |
| 80        | 80      | tcp      | 0.0.0.0/0 |

Egress

| from_port | to_port | protocol | source    |
| --------- | ------- | -------- | --------- |
| 0         | 0       | -1 (all) | 0.0.0.0/0 |

---

### Routing

Module Path

[../../modules/networking/route](/solutions/terraform/modules/networking/route)

#### Public Subnet Table

| cidr destination | gateway          |
| ---------------- | ---------------- |
| 0.0.0.0/0        | internet gateway |
| vpc cidr         | local            |

#### Private Subnet Table

| cidr destination | gateway     |
| ---------------- | ----------- |
| 0.0.0.0/0        | nat gateway |
| vpc cidr         | local       |
