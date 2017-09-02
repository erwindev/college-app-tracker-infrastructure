output "web_elb_hostname" {
  value = "${module.web.elb.hostname}"
}

output "ci_elb_hostname" {
  value = "${module.ci.elb.hostname}"
}

output "web_private_instance_ips" {
	value = "${module.web.private.instance.ips}"
}

output "ci_master_private_instance_ips" {
	value = "${module.ci.master.instance.ips}"
}

output "ci_worker_private_instance_ips" {
	value = "${module.ci.worker.instance.ips}"
}

output "bastion_instance_ip" {
	value = "${module.vpc.bastion.ip}"
}