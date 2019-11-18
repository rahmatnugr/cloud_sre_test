output "vpc_cidr" {
  value = aws_vpc.vpc.cidr_block
}

output "id" {
  value = aws_vpc.vpc.id
}
