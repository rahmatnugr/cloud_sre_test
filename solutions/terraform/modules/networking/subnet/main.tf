terraform {
  required_version = ">= 0.12, < 0.13"
}

resource "aws_subnet" "subnet" {
  count = length(var.cidr_blocks)

  vpc_id                  = var.vpc_id
  cidr_block              = var.cidr_blocks[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = var.is_public

  tags = merge(
    {
      Name = "${var.name_prefix}_${count.index}"
    },
    var.tags
  )
}
