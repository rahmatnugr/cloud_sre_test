# `data-stores` part

## Quick command
```sh
terraform init -backend-config=../config/s3-backend.conf

terraform workspace new dev

terraform plan -out=data-stores.tfplan -var-file=data-stores.tfvars

terraform apply data-stores.tfplan

terraform destroy -var-file=data-stores.tfvars
```