locals {
  zone_prefix = "${var.dev_subdomain == "true" && var.env != "live" ? "dev." : ""}"
  zone = "${local.zone_prefix}${var.domain}"
  name = "${var.env == "live" ? "" : "${var.env}-"}${var.name}"
  fqdn = "${local.name}.${local.zone}"
}

data "aws_route53_zone" "dns_domain" {
  name = "${local.zone}"
}

resource "aws_route53_record" "dns_record" {
  count = "${1 - var.alias}"

  zone_id = "${data.aws_route53_zone.dns_domain.zone_id}"
  name    = "${local.fqdn}"

  type    = "CNAME"
  records = ["${var.target}"]
  ttl     = "${var.ttl}"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_route53_record" "alb_alias" {
  count = "${var.alias}"

  zone_id = "${data.aws_route53_zone.dns_domain.zone_id}"
  name    = "${local.fqdn}"
  type    = "A"

  alias {
    name                   = "${var.target}"
    zone_id                = "${var.alb_zone_id}"
    evaluate_target_health = true
  }

  lifecycle {
    prevent_destroy = true
  }
}
