terraform {
  required_version = ">= 0.12, < 0.13"
}

resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block

  tags = merge(
    {
      Name = var.name
    },
    var.tags
  )
}
