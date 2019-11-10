# Terraform Project Directory for Chatapp Solution 2

This terraform project using version `0.12.13`. All of terraform modules are configured to use terraform version minimum `0.12.x` and below `0.13.x`.


## Initialization
1. Copy `config/s3-backend.conf.sample` to `config/s3-backend.conf` 
2. Configure all remote state s3 backend configuration (bucket, encryption, region, etc.) to `config/s3-backend.conf`
3. Make sure AWS credentials for accessing those s3 bucket are configured in credentials file (`~/.aws/credentials`) 
4. Run `terraform init -backend-config=../config/s3-backend.conf` inside all subdirectory, except directory `config`, for initializing backend, provider, and modules for each part
5. Finally, you can continue to run `terraform plan` and `terraform apply` to each part of this project

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
