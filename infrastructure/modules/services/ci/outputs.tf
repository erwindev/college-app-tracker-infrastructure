output "elb_hostname" {
  value = aws_elb.ci.dns_name
}

output "master_instance_ips" {
  value = [aws_instance.ci.*.private_ip]
}

output "worker_instance_ips" {
  value = [aws_instance.ci_worker.*.private_ip]
}
