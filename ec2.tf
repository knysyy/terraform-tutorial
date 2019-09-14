resource "aws_instance" "terraform-web-ec2" {
  ami                         = "${var.ami}"
  key_name                    = "${var.key_name}"
  associate_public_ip_address = true
  availability_zone           = "${var.aws_zone_1a}"
  disable_api_termination     = false
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${aws_subnet.terraform-web-subnet.id}"
  tenancy                     = "default"
  vpc_security_group_ids      = ["${aws_security_group.terraform-web-sg.id}"]

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }

  user_data = "${file("install_nginx.sh")}"

  tags = {
    "Name" = "terraform-web-ec2"
  }
}


