output "natgw_route_id" {
  value = aws_route.natgw.0.id
}

output "natgw_route_assoc_id" {
  value = aws_route_table_association.natgw[*].id
}

output "igw_route_id" {
  value = aws_route.igw[0].id
}

output "igw_route_assoc_id" {
  value = aws_route_table_association.igw[*].id
}
