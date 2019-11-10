terraform {
  required_version = ">= 0.12, < 0.13"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = var.vpc_id

  tags = merge(
    {
      Name = var.igw_name
    },
    var.tags
  )
}

resource "aws_eip" "natgw_eip" {
  vpc = true

  tags = merge(
    {
      Name = "${var.natgw_name}_eip"
    },
    var.tags
  )

  depends_on = [aws_internet_gateway.gw]
}

resource "aws_subnet" "natgw_subnet" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.natgw_subnet_cidr
  map_public_ip_on_launch = true

  tags = merge(
    {
      Name = "${var.natgw_name}_subnet"
    },
    var.tags
  )
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.natgw_eip.id
  subnet_id     = aws_subnet.natgw_subnet.id

  depends_on = [aws_internet_gateway.gw]

  tags = merge(
    {
      Name = var.natgw_name
    },
    var.tags
  )
}

resource "aws_route_table" "route_table_private" {
  vpc_id = var.vpc_id

  tags = merge(
    {
      Name = "route_table_private"
    },
    var.tags
  )
}

resource "aws_route_table" "route_table_public" {
  vpc_id = var.vpc_id

  tags = merge(
    {
      Name = "route_table_public"
    },
    var.tags
  )
}
