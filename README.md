# terraform
Terraform code which creates the following resources:
1. VPC
2. Subnets (1 Private and 2 Public)
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


# To run
Create a `secrets.tfvars` file which contains the following (these will be the default credentials to log into MySQL:
```
db_username = "user"
db_password = "password"
```
With the `secrets.tfvars` file created run the following commands:
```
terraform init
terraform plan
terraform apply -var-file="secrets.tfvars"
```

# After Successful Deployment
After a successful deployment any file added to the CodeCommit repository will be automatically pushed out to the EC2 instance according to the instructions in the `appspec.yml` configuration file
