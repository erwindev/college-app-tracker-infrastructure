# College ETL Application Environment Setup

This project contains the Terraform scripts to setup the infrastructure needed to run the College ETL Application.

## Steps to Setup
1. Install terraform
2. Add your AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY in your environment variables.
```
export AWS_ACCESS_KEY_ID="AKIAIW3EM34DFUH35OOA"
export AWS_SECRET_ACCESS_KEY="l0VQISbewlXALKlJh/6DBBmiKFnZRll9nVzpx3RK"
```
3. If you are using modules, make sure to invoke `$ terraform get`.
4. Go to `dev` folder.
5. Run `terraform plan` to see what is going to be applied by Terraform.
6. Run `terraform apply`
7. Login to your AWS Console to see all the resources that were created.

Please note that Amazon will charge for all the resources you are using.  In order to avoid this, you can shutdown and delete all the resources that you created.  To do this, you need to `terraform destroy` the resources.

```
$ open "http://$(terraform elb_hostname)"
```

https://thecode.pub/creating-your-cloud-servers-with-terraform-bfa01a499bad
