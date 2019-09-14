resource "aws_acm_certificate" "terraform-web-cert" {
  domain_name       = "${var.aws_acm_sub_domain_name}"
  validation_method = "DNS"
}

# 認証中は取得不可能？
# data "aws_acm_certificate" "terraform-web-cert" {
#   domain      = "${var.aws_acm_sub_domain_name}"
#   key_types         = ["RSA_2048"]
# }

resource "aws_route53_zone" "terraform-web-zone" {
  force_destroy = false
  name          = "${var.aws_domain_name}"
}

resource "aws_route53_record" "terraform-web-zone" {
  zone_id = "${aws_route53_zone.terraform-web-zone.zone_id}"
  name    = "${var.aws_sub_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_lb.terraform-web-lb.dns_name}"
    zone_id                = "${aws_lb.terraform-web-lb.zone_id}"
    evaluate_target_health = true
  }
}
