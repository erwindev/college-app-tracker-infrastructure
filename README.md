# College ETL Application Environment Setup

This project contains the Terraform scripts to setup the infrastructure needed to run the College ETL Application.

## Pre-requisites
1. Signup for an AWS Account
2. Install [Terraform](https://www.terraform.io/downloads.html)
3. Install [Ansible](http://docs.ansible.com/ansible/latest/intro_installation.html)

## Steps to Setup
1. Install terraform
2. Add your AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY in your environment variables.
```
export AWS_ACCESS_KEY_ID="aws_access_key"
export AWS_SECRET_ACCESS_KEY="aws_secret_key"
```
3. Go to `infrastructure\dev` folder.
4. Create an SSH key pair using "dev_key" as the name. 
```
$ ssh-keygen -q -f dev_key -C aws_terraform_ssh_key -N ''
```
5. If you are using modules, make sure to invoke `$ terraform get`.
6. Run `terraform plan` to see what Terraform is going to be applied in your AWS environment. 
7. Run `terraform apply` to start spinning up your environment.
8. Login to your AWS Console to see all the resources that were created.

## Access the fresh NGINX webserver
1. Since we installed an ELB in front of the nginx server, we need to get the IP of the ELB server.
```
$ open "http://$(terraform output elb_hostname)"
```

## SSH into your AWS EC2 Instances
In order to access your instances you will need to SSH to the bastion server.  From the bastion server, you can then ssh into your AWS EC2 Instances that were created within your private subnet.
1. Change the access file permission of the public key that you used in setting up your AWS instances.  In our case, it is the `dev_key.pub` file.
```
$ chmod 400 dev_key.pub
```
2. Add the your key to the list of maintained by ssh-agent.
```
$ ssh-add -K dev_key
```
3. SSH to the bastion server.  In order to do this, you will need the public IP of your bastion server.  Go to you Amazon Console to get this information.
```
$ ssh -A ubuntu@<public ip of your bastion server>
```
4. Once you are ssh'd in your bastion server, you can then ssh to your other servers.
```
$ ssh ubuntu@<private ip>
```

Please note that Amazon will charge you for all the resources you are using.  In order to avoid this, you can shutdown and delete all the resources that you created.  To do this, you need to `terraform destroy` the resources.


## Ansible
We are going to use Ansible to configure our newly provisioned servers.  In the `configuration` directory are configuration files and Ansible playbooks to apply configurations to our servers.  

#### Setting up Ansible to go through our bastion host
When we setup our environment, we created the bastion host.  The bastion host provided access to the private network from an external network.  To get access to our servers installed in the private subnet, we must first SSH to the bastion server.  Once logged in to the bastion server, we are allowed to ssh to the servers in the private network.  

To run Ansible playbook against the servers inside the private subnet, we do the following:
1. Create an `inventory` file.
```
[bastion]
bastion.erwindev.com

[web_servers]
10.0.5.92
10.0.5.54
```
2.  Ansible uses SSH for virtuall all of its operations.  As such, we have to setup an `ssh.cfg` file that contains a few settings on how we communicate to our servers via SSH.
```
Host 10.0.5.*
  ProxyCommand    ssh -W %h:%p ubuntu@bastion.erwindev.com

Host *
  ControlMaster   auto
  ControlPath     ~/.ssh/mux-%r@%h:%p
  ControlPersist  15m
```
This tells us that access to 10.0.2.* hosts are proxied via the bastion hosts.  The Control settings are configured to apply to every host and lets SSH reuse already established connections for a set amount of time (used for speeding up executiono of playbooks).
3.  Create an `ansible.cfg` file to let Ansible know to use our the `ssh.cfg` when trying to access our servers.
```
[ssh_connection]
ssh_args = -F ssh.cfg
control_path = ~/.ssh/mux-%r@%h:%p
```
4. Run the test_connection playbook.  
`$ ansible-playbook -i inventory test_connection.yml`
5. Install packages
`$ ansible-playbook -i inventory install_packages.yml`
