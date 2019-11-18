terraform {
  required_version = ">= 0.12, < 0.13"
}

resource "aws_route53_zone" "dns" {
  name = var.root_domain_name

  tags = merge(
    {
      Name = "${var.name_prefix}_zone"
    },
    var.tags
  )
}

resource "aws_route53_record" "records" {
  count = length(var.dns_records)

  zone_id = "${aws_route53_zone.dns.zone_id}"
  name    = var.dns_records[count.index].name
  type    = var.dns_records[count.index].type
  ttl     = var.ttl

  records = var.dns_records[count.index].records
}
