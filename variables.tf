variable "aws_region" {

  type = string

  default = "us-east-2"
}



variable "vpc_cidr" {

  type = string

  default = "10.0.0.0/16"

}

variable "public_subnet" {

  type = string

  default = "10.0.1.0/24"

}

variable "instance_type" {

  type = string

  default = "c7i-flex.large"

}

variable "allowed_ports" {

  type = list(number)

  default = [22, 80, 443]

}

variable "environment" {

  type = string

  default = "dev"

}

variable "availability_zone" {

  type = string

  default = "us-east-2a"

}

variable "ami_id" {

  type = string

  default = "ami-0fe18bc3cfa53a248"

}


