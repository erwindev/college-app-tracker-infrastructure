/* Security group for the docker */
resource "aws_security_group" "docker_server_sg" {
  name        = "${var.environment}-docker-server-sg"
  description = "Security group for docker that allows http(s), ssh and swarm traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  ingress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }  

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
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
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }   

  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }    

  ingress {
    from_port   = 5432
    to_port     = 5432
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

  tags = {
    Name        = "${var.environment}-docker-server-sg"
    Environment = var.environment
  }
}

resource "aws_security_group" "docker_inbound_sg" {
  name        = "${var.environment}-docker-inbound-sg"
  description = "Allow ssh, http, swarm traffic from Anywhere"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }    

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }     

  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }    

  ingress {
    from_port   = 9090
    to_port     = 9090
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

  tags = {
    Name = "${var.environment}-docker-inbound-sg"
  }
}

/* docker servers */
resource "aws_instance" "docker" {
  count             = var.docker_instance_count
  ami               = lookup(var.amis, var.region)
  instance_type     = var.instance_type
  subnet_id         = var.private_subnet_id
  vpc_security_group_ids = [
    aws_security_group.docker_server_sg.id
  ]
  key_name          = var.key_name
  tags = {
    Name        = "${var.environment}-docker-{count.index+1}"
    Environment = var.environment
  }
}

/* Load Balancer */
resource "aws_elb" "docker" {
  name            = "${var.environment}-docker-lb"
  subnets         = [var.public_subnet_id]
  security_groups = [aws_security_group.docker_inbound_sg.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  listener {
    instance_port     = 8080
    instance_protocol = "http"
    lb_port           = 8080
    lb_protocol       = "http"
  }

  instances = [aws_instance.docker[0].id, aws_instance.docker[1].id]

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    target              = "TCP:8080"
    interval            = 10
  }    

  tags = {
    Environment = var.environment
  }
}

/* College App Tracker docker Site Bucket */
resource "aws_s3_bucket" "college-app-tracker-site" {
  bucket = "${var.public_subdomain}.${var.root_domain}"
  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}

/* College App Tracker CloudFront */
resource "aws_cloudfront_distribution" "college-app-tracker-distribution" {
    origin {
        custom_origin_config {
            http_port = 80
            https_port = 443
            origin_protocol_policy = "http-only"
            origin_ssl_protocols = ["SSLv3", "TLSv1", "TLSv1.1", "TLSv1.2"]
        }
        domain_name = aws_s3_bucket.college-app-tracker-site.bucket_domain_name
        origin_id   = aws_s3_bucket.college-app-tracker-site.id
    }

    enabled = true
    default_root_object = "index.html"
    aliases = ["${var.public_subdomain}.${var.root_domain}"]

    custom_error_response {
       error_code         = 404
       response_code      = 200
       response_page_path = "/404.html"
    }

    http_version = "http2"

    default_cache_behavior {
        allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
        cached_methods   = ["GET", "HEAD"]
        target_origin_id = aws_s3_bucket.college-app-tracker-site.id

        forwarded_values {
          query_string = false

          cookies {
            forward = "none"
          }
        }

        viewer_protocol_policy = "allow-all"
        min_ttl                = 0
        default_ttl            = 3600
        max_ttl                = 86400
    }

    price_class = "PriceClass_All"

    restrictions {
        geo_restriction {
            restriction_type = "none"
        }
    }

    viewer_certificate {
        cloudfront_default_certificate = true
    }
}