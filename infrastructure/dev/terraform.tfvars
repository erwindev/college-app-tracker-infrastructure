environment         = "dev"
key_name            = "test"
region              = "us-east-1"
availability_zone   = "us-east-1a"

# vpc
vpc_cidr            = "10.0.0.0/16"
public_subnet_cidr  = "10.0.1.0/24"
private_subnet_cidr = "10.0.2.0/24"

# web
docker_instance_count  = 2
public_subdomain       = "www"
root_domain            = "erwindev.com"
