output "elb_hostname" {
  value = aws_elb.docker.dns_name
}

output "private_instance_ips" {
  value = [aws_instance.docker.*.private_ip]
}
