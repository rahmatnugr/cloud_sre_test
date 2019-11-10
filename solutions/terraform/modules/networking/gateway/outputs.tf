output "igw_id" {
  value = aws_internet_gateway.gw.id
}

output "natgw_id" {
  value = aws_nat_gateway.natgw.id
}

output "route_table_private" {
  value = aws_route_table.route_table_private.id
}

output "route_table_public" {
  value = aws_route_table.route_table_public.id
}
