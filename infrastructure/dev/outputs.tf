output "web_elb_hostname" {
  value = "${module.web.elb.hostname}"
}

output "ci_elb_hostname" {
  value = "${module.ci.elb.hostname}"
}

output "web_private_instance_ips" {
	value = "${module.web.private.instance.ips}"
}

output "ci_private_instance_ips" {
	value = "${module.ci.private.instance.ips}"
}

output "bastion_instance_ip" {
	value = "${module.vpc.bastion.ip}"
}