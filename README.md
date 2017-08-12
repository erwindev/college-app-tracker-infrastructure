# College ETL Application Environment Setup

This project contains the Terraform scripts to setup the infrastructure needed to run the College ETL Application.

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


