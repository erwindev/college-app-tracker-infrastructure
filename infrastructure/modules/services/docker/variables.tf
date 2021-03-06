variable "docker_instance_count" {
  description = "The total of docker instances to run"
}

variable "region" {
  description = "The region to launch the instances"
}

variable "amis" {
  default = {
    "us-east-1" = "ami-f4eeed8f"
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

variable "public_subdomain" {
  description = "Public subdomain"
}

variable "root_domain" {
    description = "Root domain"
}
