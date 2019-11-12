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

output "alb_sg_id" {
  value = module.alb_sg.id
}

output "alb_id" {
  value = module.alb.id
}

output "alb_dns_name" {
  value = module.alb.dns_name
}