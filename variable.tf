variable "prefix" {
  default = "skills"
}

variable "region" {
  default = "ap-northeast-2"
}

variable "profile" {
  default = "default"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_a_cidr" {
  default = "10.0.10.0/24"
}

variable "public_subnet_b_cidr" {
  default = "10.0.20.0/24"
}

variable "private_subnet_a_cidr" {
  default = "10.0.30.0/24"
}

variable "instance_type" {
  default = "t3.small"
}
