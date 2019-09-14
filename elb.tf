resource "aws_lb" "terraform-web-lb" {
  name                       = "terraform-web-lb"
  enable_deletion_protection = false
  enable_http2               = true
  internal                   = false
  security_groups = [
    "${aws_security_group.terraform-web-elb-sg.id}",
  ]
  subnets = [
    "${aws_subnet.terraform-web-subnet-alb1.id}",
    "${aws_subnet.terraform-web-subnet-alb2.id}",
  ]
}

resource "aws_lb_target_group" "terraform-web-target" {
  deregistration_delay = 300
  name                 = "terraform-web-target-group"
  port                 = 80
  protocol             = "HTTP"
  slow_start           = 0
  tags                 = {}
  target_type          = "instance"
  vpc_id               = "${aws_vpc.terraform-web-vpc.id}"

  health_check {
    enabled             = true
    healthy_threshold   = 5
    interval            = 30
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

  stickiness {
    cookie_duration = 86400
    enabled         = false
    type            = "lb_cookie"
  }
}

resource "aws_lb_target_group_attachment" "terraform-web-attach" {
  count            = 2
  target_group_arn = "${aws_lb_target_group.terraform-web-target.arn}"
  target_id        = "${aws_instance.terraform-web-ec2.id}"
  port             = 80
}

resource "aws_lb_listener" "terraform-web-listener1" {
  load_balancer_arn = "${aws_lb.terraform-web-lb.arn}"
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.terraform-web-target.arn}"
    type             = "forward"
  }
}

# resource "aws_lb_listener" "terraform-web-listener1" {
#   load_balancer_arn = "${aws_lb.terraform-web-lb.arn}"
#   port              = 80
#   protocol          = "HTTP"

#   default_action {
#     type = "redirect"

#     redirect {
#       port        = 443
#       protocol    = "HTTPS"
#       status_code = "HTTP_301"
#     }
#   }
# }

// acm検証中はエラーになる？
# resource "aws_lb_listener" "terraform-web-listener2" {
#   load_balancer_arn = "${aws_lb.terraform-web-lb.arn}"
#   port              = 443
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = "${aws_acm_certificate.terraform-web-cert.arn}"

#   default_action {
#     target_group_arn = "${aws_lb_target_group.terraform-web-target.arn}"
#     type             = "forward"
#   }
# }
