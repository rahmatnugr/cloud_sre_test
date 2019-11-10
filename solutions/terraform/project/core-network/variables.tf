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
  default     = "default"
}

variable "cidr" {
  description = "VPC CIDR blocks"
  type        = map
  default = {
    dev     = "10.3.0.0/16"
    stag    = "10.2.0.0/16"
    prod    = "10.1.0.0/16"
    default = "10.0.0.0/16"
  }
}

variable "natgw_subnet_cidr" {
  description = "NAT Gateway subnet CIDR block"
  type        = map
  default = {
    dev     = "10.3.255.0/28"
    stag    = "10.2.255.0/28"
    prod    = "10.1.255.0/28"
    default = "10.0.255.0/28"
  }
}

variable "pub_subnet_cidr_blocks" {
  description = "CIDR block for public subnet (for LB purposes)"
  type        = map
  default = {
    dev     = ["10.3.1.0/28", "10.3.1.16/28", "10.3.1.32/28"]
    stag    = ["10.2.1.0/28", "10.2.1.16/28", "10.2.1.32/28"]
    prod    = ["10.1.1.0/28", "10.1.1.16/28", "10.1.1.32/28"]
    default = ["10.0.1.0/28", "10.0.1.16/28", "10.0.1.32/28"]
  }
}

variable "priv_fargate_subnet_cidr_blocks" {
  description = "CIDR block for fargate private subnet (for backend compute purposes)"
  type        = map
  default = {
    dev     = ["10.3.2.0/24", "10.3.3.0/24", "10.3.4.0/24"]
    stag    = ["10.2.2.0/24", "10.2.3.0/24", "10.2.4.0/24"]
    prod    = ["10.1.2.0/24", "10.1.3.0/24", "10.1.4.0/24"]
    default = ["10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"]
  }
}
