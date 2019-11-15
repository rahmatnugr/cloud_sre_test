# `distribution` part

## Quick command
```sh
terraform init -backend-config=../config/s3-backend.conf

terraform workspace new dev

terraform plan -out=distribution.tfplan -var-file=distribution.tfvars

terraform apply distribution.tfplan

terraform destroy -var-file=distribuion.tfvars
```