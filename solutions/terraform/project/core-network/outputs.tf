output "vpc_id" {
  value = module.vpc.id
}

output "natgw_id" {
  value = module.gw.natgw_id
}

output "igw_id" {
  value = module.gw.igw_id
}

output "pub_subnet_ids" {
  value = module.pub_subnet.subnet_ids
}

output "priv_fargate_subnet_ids" {
  value = module.priv_fargate_subnet.subnet_ids
}
