provider "aws" {
  region          = "${var.region}"
}

resource "aws_key_pair" "key" {
  key_name   = "${var.key_name}"
  public_key = "${file("dev_key.pub")}"
}

module "vpc" {
  source              = "../modules/services/vpc"
  environment         = "${var.environment}"
  vpc_cidr            = "${var.vpc_cidr}"
  public_subnet_cidr  = "${var.public_subnet_cidr}"
  private_subnet_cidr = "${var.private_subnet_cidr}"
  region              = "${var.region}"
  availability_zone   = "${var.availability_zone}"
  key_name            = "${var.key_name}"
}

module "docker" {
  source                      = "../modules/services/docker"
  docker_instance_count       = "${var.docker_instance_count}"
  region                      = "${var.region}"
  instance_type               = "t2.small"
  private_subnet_id           = "${module.vpc.private_subnet_id}"
  public_subnet_id            = "${module.vpc.public_subnet_id}"
  vpc_sg_id                   = "${module.vpc.default_sg_id}"
  key_name                    = "${var.key_name}"
  environment                 = "${var.environment}"
  vpc_id                      = "${module.vpc.vpc_id}"
  vpc_cidr_block              = "${var.vpc_cidr}"
  public_subdomain            = "${var.public_subdomain}"
  root_domain                 = "${var.root_domain}"
}

module "ci" {
  source              = "../modules/services/ci"
  region              = "${var.region}"
  instance_type       = "t2.micro"
  private_subnet_id   = "${module.vpc.private_subnet_id}"
  public_subnet_id    = "${module.vpc.public_subnet_id}"
  vpc_sg_id           = "${module.vpc.default_sg_id}"
  key_name            = "${var.key_name}"
  environment         = "${var.environment}"
  vpc_id              = "${module.vpc.vpc_id}"
  vpc_cidr_block      = "${var.vpc_cidr}"

}
