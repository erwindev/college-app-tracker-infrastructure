/* Security group for the web */
resource "aws_security_group" "web_server_sg" {
  name        = "${var.environment}-web-server-sg"
  description = "Security group for web that allows http(s), ssh and swarm traffic"
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
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["${var.vpc_cidr_block}"]
  }  

  ingress {
    from_port   = 2377
    to_port     = 2377
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 7946
    to_port     = 7946
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 7946
    to_port     = 7946
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 4789
    to_port     = 4789
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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
    Name        = "${var.environment}-web-server-sg"
    Environment = "${var.environment}"
  }
}

resource "aws_security_group" "web_inbound_sg" {
  name        = "${var.environment}-web-inbound-sg"
  description = "Allow ssh, http, swarm traffic from Anywhere"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
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
    Name = "${var.environment}-web-inbound-sg"
  }
}

/* Web servers */
resource "aws_instance" "web" {
  count             = "${var.web_instance_count}"
  ami               = "${lookup(var.amis, var.region)}"
  instance_type     = "${var.instance_type}"
  subnet_id         = "${var.private_subnet_id}"
  vpc_security_group_ids = [
    "${aws_security_group.web_server_sg.id}"
  ]
  key_name          = "${var.key_name}"
  user_data         = "${file("${path.module}/files/user_data.sh")}"
  tags = {
    Name        = "${var.environment}-web-${count.index+1}"
    Environment = "${var.environment}"
  }
}

/* Load Balancer */
resource "aws_elb" "web" {
  name            = "${var.environment}-web-lb"
  subnets         = ["${var.public_subnet_id}"]
  security_groups = ["${aws_security_group.web_inbound_sg.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  instances = ["${aws_instance.web.*.id}"]

  tags {
    Environment = "${var.environment}"
  }
}
