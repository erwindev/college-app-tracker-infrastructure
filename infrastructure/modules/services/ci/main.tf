/* Security group for CI server */
resource "aws_security_group" "ci_sg" {
  name        = "${var.environment}-ci-server-sg"
  description = "Security group for CI that allows traffic"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["${var.vpc_cidr_block}"]
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["${var.vpc_cidr_block}"]
  }

  ingress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
    cidr_blocks = ["${var.vpc_cidr_block}"]
  }  

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "${var.environment}-ci-server-sg"
    Environment = "${var.environment}"
  }
}

resource "aws_security_group" "ci_inbound_sg" {
  name        = "${var.environment}-ci-inbound-sg"
  description = "Allow HTTP and ssh from Anywhere"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }  

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.environment}-ci-inbound-sg"
  }
}

/* CI master */
resource "aws_instance" "ci" {
  count             = "1"
  ami               = "${lookup(var.amis, var.region)}"
  instance_type     = "${var.instance_type}"
  subnet_id         = "${var.private_subnet_id}"
  vpc_security_group_ids = [
    "${aws_security_group.ci_sg.id}"
  ]
  key_name          = "${var.key_name}"
  tags = {
    Name        = "${var.environment}-ci"
    Environment = "${var.environment}"
  }
}

/* CI worker */
resource "aws_instance" "ci_worker" {
  count             = "1"
  ami               = "${lookup(var.amis, var.region)}"
  instance_type     = "${var.instance_type}"
  subnet_id         = "${var.private_subnet_id}"
  vpc_security_group_ids = [
    "${aws_security_group.ci_sg.id}"
  ]
  key_name          = "${var.key_name}"
  tags = {
    Name        = "${var.environment}-ci"
    Environment = "${var.environment}"
  }
}

/* Load Balancer */
resource "aws_elb" "ci" {
  name            = "${var.environment}-ci-lb"
  subnets         = ["${var.public_subnet_id}"]
  security_groups = ["${aws_security_group.ci_inbound_sg.id}"]

  listener {
    instance_port     = 8080
    instance_protocol = "http"
    lb_port           = 8080
    lb_protocol       = "http"
  }
  instances = ["${aws_instance.ci.id}"]

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    target              = "TCP:8080"
    interval            = 10
  }  

  tags {
    Environment = "${var.environment}"
  }
}
