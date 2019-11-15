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
# App related variable
# ----

variable "app_port" {
  description = "Port that app listen to"
  type        = number
  default     = 80
}

variable "cpu" {
  description = "CPU value for running app"
  type        = number
  default     = 512
}

variable "memory" {
  description = "Memory value for running app"
  type        = number
  default     = 1024
}

variable "min_capacity" {
  description = "Minimum capacity count running fargate task"
  type        = number
  default     = 3
}

variable "max_capacity" {
  description = "Maximum capacity count running fargate task"
  type        = number
  default     = 6
}

variable "high_cpu_threshold" {
  description = "Upper CPU percentage threshold for triggering auto scale out"
  type        = number
  default     = 70
}

variable "low_cpu_threshold" {
  description = "Lower CPU percentage threshold for triggering auto scale in"
  type        = number
  default     = 10
}

variable "desired_count" {
  description = "Desired count running fargate task"
  type        = number
  default     = 3
}

# ----
# App credentials related variable
# Example only, not recommended for production env, please put credentials in secure place
# Eg. Vault
# ----
variable "mysql_username" {
  type = string
}

variable "mysql_password" {
  type = string
}
