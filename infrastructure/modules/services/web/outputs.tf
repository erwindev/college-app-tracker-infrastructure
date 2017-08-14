output "elb.hostname" {
  value = "${aws_elb.web.dns_name}"
}

output "private.instance.ips" {
  value = ["${aws_instance.web.*.private_ip}"]
}
