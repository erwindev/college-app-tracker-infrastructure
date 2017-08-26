variable "region" {
  description = "The region to launch the instances"
}

variable "amis" {
  description = "Ubuntu 16.04 (python, ansible, node, npm, angular, docker)"
  default = {
    "us-east-1" = "ami-95faf9ee"
  }
}

variable "instance_type" {
  description = "The instance type to launch"
}

variable "private_subnet_id" {
  description = "The id of the private subnet to launch the instances"
}

variable "vpc_sg_id" {
  description = "The default security group from the vpc"
}

variable "public_subnet_id" {
  description = "The id of the public subnet to launch the load balancer"
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
