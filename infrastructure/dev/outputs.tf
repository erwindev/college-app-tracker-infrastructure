output "docker_elb_hostname" {
  value = module.docker.elb_hostname
}

output "ci_elb_hostname" {
  value = module.ci.elb_hostname
}

output "docker_private_instance_ips" {
	value = module.docker.private_instance_ips
}

output "ci_master_private_instance_ips" {
	value = module.ci.master_instance_ips
}

output "ci_worker_private_instance_ips" {
	value = module.ci.worker_instance_ips
}

output "bastion_instance_ip" {
	value = module.vpc.bastion_ip
}