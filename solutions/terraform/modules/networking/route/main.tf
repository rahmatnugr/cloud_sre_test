terraform {
  required_version = ">= 0.12, < 0.13"
}

resource "aws_route" "natgw" {
  count = var.is_natgw ? 1 : 0

  route_table_id         = var.natgw_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.natgw_id
}

resource "aws_route_table_association" "natgw" {
  count = var.is_natgw ? length(var.natgw_subnet_ids) : 0

  subnet_id      = var.natgw_subnet_ids[count.index]
  route_table_id = var.natgw_route_table_id
}

resource "aws_route" "igw" {
  count = var.is_igw ? 1 : 0

  route_table_id         = var.igw_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.igw_id
}

resource "aws_route_table_association" "igw" {
  count = var.is_igw ? length(var.igw_subnet_ids) : 0

  subnet_id      = var.igw_subnet_ids[count.index]
  route_table_id = var.igw_route_table_id
}
