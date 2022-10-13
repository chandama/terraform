# terraform
Terraform code which creates the following resources:
1. VPC
2. Subnets
    * Private
    * Public x2
4. Route Tables
5. Internet Gateway
6. NAT Gateway
7. Elastic IP
8. IAM Roles
    * EC2
    * CodePipeline
    * CodeDeploy
10. Security Groups
    * EC2
    * DB  
11. S3 Buckets
    * Web Assets
    * Code Pipeline Artifacts  
12. EC2
13. RDS
    * MySQL Instance
15. CodeCommit Repository
16. CodeDeploy Application
17. CodePipeline

# Prerequisites
To build this stack you must have `terraform` and the `aws-cli` installed and running your machine.
https://learn.hashicorp.com/tutorials/terraform/install-cli

https://learn.hashicorp.com/tutorials/terraform/aws-build

You will also need to have an AWS account with a user configured with an `AWS_ACCESS_KEY` and `AWS_SECRET_ACCESS_KEY` which will allow Terraform to login to your AWS account and create resources on your behalf. These AWS access keys need to be stored as local environment variables.

https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys

# To run
Create a `secrets.tfvars` file in the same directory as your `.tf` files which contains the following credentials::
```
db_username = "user"
db_password = "password"
```
`db_username` and `db_password` will be the credentials used to access the MySQL database.

With the `secrets.tfvars` file created run the following commands:
```
terraform init
terraform plan
terraform apply -var-file="secrets.tfvars"
```

# After Successful Deployment
After a successful deployment any file added to the CodeCommit repository will be automatically pushed out to the EC2 instance according to the instructions in the `appspec.yml` configuration file

# Check MySQL
The MySQL database running on the AWS RDS database instance is located in the VPC Private Subnet and is only accessable via the EC2 Webserver Instance. While SSH'd into the EC2 instance run the following command to connect to the MySQL database service:
```
 mysql -u <user> -p -h <hostname>
```
The `<user>` above comes from the `secrets.tfvars` file created earlier
`<hostname>` is the AWS RDS endpoint that is created and can be accessed in the AWS RDS Console or the output variable after a successful `terraform apply`

You will be prompted for a password which is the `db_password` field from the `secrets.tfvars` file

# Clean-up
In order to clean up resources in your environment to prevent excess costs, run the following command:
```
terraform destroy
```
Enter 'Yes' when prompted and make sure that all of the resources are successfully deleted.

If you ran any CodePipeline runs, there will be output artifacts in the S3 CodePipeline bucket that will need to be deleted manually and then the bucket can be successfully deleted by running `terraform destroy` again or manually from the AWS GUI in the S3 section.

Similarly, if you manually put any objects in the `s3-web-assets` bucket, you will have to delete those objects before the bucket can be deleted.
