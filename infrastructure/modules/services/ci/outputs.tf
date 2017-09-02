output "elb.hostname" {
  value = "${aws_elb.ci.dns_name}"
}

output "master.instance.ips" {
  value = ["${aws_instance.ci.private_ip}"]
}

output "worker.instance.ips" {
  value = ["${aws_instance.ci_worker.private_ip}"]
}
