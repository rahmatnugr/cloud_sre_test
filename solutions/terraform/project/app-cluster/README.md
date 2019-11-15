# `app-cluster` part

## Quick command
```sh
terraform init -backend-config=../config/s3-backend.conf

terraform workspace new dev

terraform plan -out=app-cluster.tfplan -var-file=app-cluster.tfvars

terraform apply app-cluster.tfplan

terraform destroy -var-file=app-cluster.tfvars
```