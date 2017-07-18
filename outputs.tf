output "fqdn" {
  value = "${aws_route53_record.dns_record.fqdn}"
}
