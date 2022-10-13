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


To run
```
terraform apply -var-file="secrets.tfvars"
```
