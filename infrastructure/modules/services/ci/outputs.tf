output "elb.hostname" {
  value = "${aws_elb.ci.dns_name}"
}

output "private.instance.ips" {
  value = ["${aws_instance.ci.private_ip}"]
}
