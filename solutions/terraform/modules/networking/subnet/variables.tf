variable "name_prefix" {
  description = "Define subnet name prefix"
  type        = string
  default     = "subnet"
}

variable "cidr_blocks" {
  description = "Define list of subnet CIDR block"
  type        = list(string)
}

variable "is_public" {
  description = "Define subnet whether is public or not"
  type        = bool
  default     = false
}

variable "azs" {
  description = "Define list of subnet AZ, mapped to subnet CIDR block"
  type        = list(string)
}

variable "vpc_id" {
  description = "Define VPC ID to be associated with this subnet"
  type        = string
}

variable "tags" {
  description = "Define subnet tags"
  type        = map
}
