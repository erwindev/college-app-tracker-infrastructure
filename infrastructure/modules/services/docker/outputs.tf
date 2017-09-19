output "elb.hostname" {
  value = "${aws_elb.docker.dns_name}"
}

output "private.instance.ips" {
  value = ["${aws_instance.docker.*.private_ip}"]
}
