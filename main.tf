data "aws_route53_zone" "dns_domain" {
  name = "${data.template_file.domain.rendered}"
}

data "template_file" "domain" {
  template = "$${env == "live" ? "$${domain}" : "dev.$${domain}"}."

  vars {
    env    = "${var.env}"
    domain = "${var.domain}"
  }
}

output "rendered" {
  value = "${data.template_file.domain.rendered}"
}

resource "aws_route53_record" "dns_record" {
  count = "${var.alias == 0 ? 1 : 0}"

  zone_id = "${data.aws_route53_zone.dns_domain.zone_id}"
  name    = "${var.env == "live" ? "${var.name}" : "${var.env}-${var.name}"}.${data.template_file.domain.rendered}"

  type    = "CNAME"
  records = ["${var.target}"]
  ttl     = "${var.ttl}"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_route53_record" "alb_alias" {
  count = "${var.alias == 1 ? 1 : 0}"

  zone_id = "${data.aws_route53_zone.dns_domain.zone_id}"
  name    = "${var.env == "live" ? "${var.name}" : "${var.env}-${var.name}"}.${data.template_file.domain.rendered}"
  type    = "A"

  alias {
    name                   = "${var.target}"
    zone_id                = "${var.alb_zone_id}"
    evaluate_target_health = true
  }

}
