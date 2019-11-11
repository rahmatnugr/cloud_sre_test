terraform {
  required_version = ">= 0.12, < 0.13"
}

resource "aws_security_group" "sg" {
  name        = var.name
  description = var.description

  vpc_id = var.vpc_id

  tags = merge(
    {
      Name = var.name
    },
    var.tags
  )
}

resource "aws_security_group_rule" "sg_rules" {
  count = length(var.rules)

  type      = var.rules[count.index].type
  from_port = var.rules[count.index].from_port
  to_port   = var.rules[count.index].to_port
  protocol  = var.rules[count.index].protocol

  # fill only one, not all
  self                     = var.rules[count.index].self
  cidr_blocks              = var.rules[count.index].cidr_blocks
  source_security_group_id = var.rules[count.index].source_security_group_id

  description = var.rules[count.index].description

  security_group_id = aws_security_group.sg.id
}
