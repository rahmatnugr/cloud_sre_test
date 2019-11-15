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
# Distribution related variable
# ----

variable "domain_name" {
  description = "Domain name (root domain) to be used"
  type        = string
}
