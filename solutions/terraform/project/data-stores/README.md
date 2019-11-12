# `data-stores` part

## Quick command
```sh
terraform init -backend-config=../config/s3-backend.conf

terraform workspace new dev

terraform plan -out=data-stores.tfplan

terraform apply data-stores.tfplan

terraform destroy
```