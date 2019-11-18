# Part `distribution`

This directory contains terraform code for provisioning part `distribution` of Chatapp AWS Infrastructure.

## Dependencies

This project part depends on remote state bucket of project part:

- `core-network`
- `data-stores`

So, make sure those parts successfully provisioned and the state stored in backend.

## Specification

This is specification of infrastructure that will be provisioned with this part.

| No. | Service/Resource |
| --- | ---------------- |
| 1   | Cloudfront CDN   |
| 2   | Route 53         |

---

### Cloudfront CDN

Module Path

[../../modules/networking/cdn](/solutions/terraform/networking/cdn)

#### Custom Domain Name

app.com

#### Certificate

Managed by ACM

#### Origin

| No. | Origin                    | Is Default Origin? | Protocol Policy |
| --- | ------------------------- | ------------------ | --------------- |
| 1   | S3 Bucket for web hosting | yes                | http-only       |
| 2   | Chatapp ALB               | No                 | http-only       |

#### Behaviour

| No. | Origin                    | Path Pattern | Is Default Behaviour |
| --- | ------------------------- | ------------ | -------------------- |
| 1   | Chatapp ALB               | /api         | No                   |
| 2   | Chatapp ALB               | /api/\*      | No                   |
| 3   | S3 Bucket for web hosting | \*           | Yes                  |

> Note: Cloudfront resource can't be provisioned until your AWS account is verified by AWS Support. Read [this](https://stackoverflow.com/questions/55084436/accessdeniedexception-while-creating-aws-web-cloudfront-distribution)

---

### Route 53

Module Path

[../../modules/networking/dns](/solutions/terraform/networking/dns)

Route Domain Name: app.com

#### DNS Record

| No. | Name                          | Type                          | Records                          |
| --- | ----------------------------- | ----------------------------- | -------------------------------- |
| 1   | \*                            | CNAME                         | [CDN Domain Name]                |
| 2   | [ACM DNS Validation DNS Name] | [ACM DNS Validation DNS Type] | [ACM DNS Validation DNS Records] |

---

## Quick command

```sh
cp distribution.tfvars.example distribution.tfvars

terraform init -backend-config=../config/s3-backend.conf

terraform workspace new dev

terraform plan -out=distribution.tfplan -var-file=distribution.tfvars

terraform apply distribution.tfplan

terraform destroy -var-file=distribuion.tfvars
```
