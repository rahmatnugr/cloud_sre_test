variable "cidr_block" {
  description = "Define CIDR block for VPC"
  type        = "string"
  default     = "0.0.0.0/0"
}

variable "tags" {
  description = "Define VPC tags"
  type        = map(string)
}

variable "name" {
  description = "Define VPC name"
  type        = string
  default     = "vpc"
}
