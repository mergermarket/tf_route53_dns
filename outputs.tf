output "fqdn" {
  value = "${var.alb_zone_id == "" ? ${aws_route53_record.dns_record.fqdn} : ${aws_route53_record.alb_alias.fqdn}}"
}
