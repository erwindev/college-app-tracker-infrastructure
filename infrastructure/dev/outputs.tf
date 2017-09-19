output "docker_elb_hostname" {
  value = "${module.docker.elb.hostname}"
}

output "ci_elb_hostname" {
  value = "${module.ci.elb.hostname}"
}

output "docker_private_instance_ips" {
	value = "${module.docker.private.instance.ips}"
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