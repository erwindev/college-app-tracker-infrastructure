output "elb_hostname" {
  value = "${module.web.elb.hostname}"
}

output "private_instance_ips" {
	value = "${module.web.private.instance.ips}"
}

output "bastion_instance_ip" {
	value = "${module.vpc.bastion.ip}"
}