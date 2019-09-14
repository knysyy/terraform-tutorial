variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "key_name" {}
variable "aws_region" {
  default = "ap-northeast-1"
}
variable "aws_zone_1a" {
  default = "ap-northeast-1a"
}

variable "aws_zone_1c" {
  default = "ap-northeast-1c"
}

variable "aws_zone_1d" {
  default = "ap-northeast-1d"
}

variable "ami" {
  default = "ami-0ab3e16f9c414dee7"
}
variable "instance_type" {
  default = "t2.micro"
}
variable aws_domain_name {}
variable aws_sub_domain_name {}
variable "aws_acm_sub_domain_name" {}
variable "my_ip" {}

variable "acm_cert_arn" {}

