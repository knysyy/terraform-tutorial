resource "aws_vpc" "terraform-web-vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "terraform-web-vpc"
  }
}

resource "aws_subnet" "terraform-web-subnet" {
  vpc_id            = "${aws_vpc.terraform-web-vpc.id}"
  cidr_block        = "10.0.10.0/24"
  availability_zone = "${var.aws_zone_1a}"

  tags = {
    Name = "terraform-web-1a"
  }
}

resource "aws_subnet" "terraform-web-subnet-alb1" {
  vpc_id            = "${aws_vpc.terraform-web-vpc.id}"
  cidr_block        = "10.0.20.0/24"
  availability_zone = "${var.aws_zone_1a}"

  tags = {
    Name = "terraform-web-alb1"
  }
}

resource "aws_subnet" "terraform-web-subnet-alb2" {
  vpc_id            = "${aws_vpc.terraform-web-vpc.id}"
  cidr_block        = "10.0.30.0/24"
  availability_zone = "${var.aws_zone_1c}"

  tags = {
    Name = "terraform-web-alb2"
  }
}

resource "aws_internet_gateway" "terraform-web-gw" {
  vpc_id = "${aws_vpc.terraform-web-vpc.id}"

  tags = {
    Name = "terraform-web-gw"
  }
}

resource "aws_route_table" "public-route" {
  vpc_id = "${aws_vpc.terraform-web-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.terraform-web-gw.id}"
  }
}

resource "aws_route_table_association" "terraform-public-subnet" {
  subnet_id      = "${aws_subnet.terraform-web-subnet.id}"
  route_table_id = "${aws_route_table.public-route.id}"
}

resource "aws_route_table_association" "terraform-public-subnet-alb1" {
  subnet_id      = "${aws_subnet.terraform-web-subnet-alb1.id}"
  route_table_id = "${aws_route_table.public-route.id}"
}

resource "aws_route_table_association" "terraform-public-subnet-alb2" {
  subnet_id      = "${aws_subnet.terraform-web-subnet-alb2.id}"
  route_table_id = "${aws_route_table.public-route.id}"
}
