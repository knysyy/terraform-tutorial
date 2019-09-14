output "ec2_ip" {
  value = "${aws_instance.terraform-web-ec2.public_ip}"
}

output "alb_dns" {
  value = "${aws_lb.terraform-web-lb.dns_name}"
}
