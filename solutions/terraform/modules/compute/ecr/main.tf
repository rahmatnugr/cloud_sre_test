terraform {
  required_version = ">= 0.12, < 0.13"
}

resource "aws_ecr_repository" "registry" {
  name                 = var.registry_name
  image_tag_mutability = var.image_mutability

  tags = merge(
    {
      Name = var.registry_name
    },
    var.tags
  )
}
