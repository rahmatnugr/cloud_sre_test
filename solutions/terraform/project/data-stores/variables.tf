# ----
# Main Variable
# ----

variable "remote_state_bucket" {
  description = "S3 Bucket name for remote state backend"
  type        = string
  default     = "chatapp-terraform-state"
}

variable "aws_region" {
  description = "AWS Region to be used"
  type        = string
  default     = "ap-southeast-1"
}

variable "aws_profile" {
  description = "Profile in AWS credentials file to be used"
  type        = string
  default     = "infradev"
}

# ----
# Data Store related Variable
# ----

variable "priv_redis_subnet_cidr_blocks" {
  description = "CIDR block for private redis subnet"
  type        = map(list(string))
  default = {
    dev     = ["10.3.5.0/24", "10.3.6.0/24", "10.3.7.0/24"]
    stag    = ["10.2.5.0/24", "10.2.6.0/24", "10.2.7.0/24"]
    prod    = ["10.1.5.0/24", "10.1.6.0/24", "10.1.7.0/24"]
    default = ["10.0.5.0/24", "10.0.6.0/24", "10.0.7.0/24"]
  }
}

variable "priv_aurora_subnet_cidr_blocks" {
  description = "CIDR block for private aurora subnet"
  type        = map(list(string))
  default = {
    dev     = ["10.3.8.0/24", "10.3.9.0/24", "10.3.10.0/24"]
    stag    = ["10.2.8.0/24", "10.2.9.0/24", "10.2.10.0/24"]
    prod    = ["10.1.8.0/24", "10.1.9.0/24", "10.1.10.0/24"]
    default = ["10.0.8.0/24", "10.0.9.0/24", "10.0.10.0/24"]
  }
}

# ----
# Data Store credentials related Variable
# ----

variable "aurora_db_name" {
  description = "Aurora database name"
  type        = string
}

variable "aurora_db_master_username" {
  description = "Aurora database master username"
  type        = string
}

variable "aurora_db_master_password" {
  description = "Aurora database master password"
  type        = string
}

# ----
# S3 related variable 
# ----
variable "domain_name" {
  description = "Domain name for app"
  type        = string
}
