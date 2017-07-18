variable "region" {
  description = "The region to launch the instances"
}

variable "amis" {
  default = {
    "us-east-1" = "ami-f652979b"
    "us-east-2" = "ami-fcc19b99"
    "us-west-1" = "ami-16efb076"
  }
}

variable "instance_type" {
  description = "The instance type to launch"
}

variable "private_subnet_id" {
  description = "The id of the private subnet to launch the instances"
}

variable "vpc_cidr_block" {
  description = "The CIDR block from the VPC"
}

variable "key_name" {
  description = "The keypair to use on the instances"
}

variable "environment" {
  description = "The environment for the instance"
}

variable "vpc_id" {
  description = "The id of the vpc"
}
