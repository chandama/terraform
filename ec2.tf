/*
*
*      EC2 Web Server Configuration
*
*/

# EC2 Instance with code to install CodeDeploy agent and Apache and download webfiles from S3 bucket
resource "aws_instance" "project1_ec2_webserver" {
    ami                     = var.ami
    subnet_id               = aws_subnet.public.id
    instance_type           = var.instance_type
    vpc_security_group_ids  = [aws_security_group.ec2_sg.id]
    iam_instance_profile    = aws_iam_instance_profile.ec2_profile.name
    associate_public_ip_address = true
    key_name                = "Project-1-keypayr"
    user_data = <<-EOF
      #!/bin/bash
      echo "Update dependencies and install CodeDeploy Agent"
      yum -y update
      yum install -y ruby
      yum install -y aws-cli
      cd /home/ec2-user
      wget https://aws-codedeploy-us-east-2.s3.us-east-2.amazonaws.com/latest/install
      chmod +x ./install
      ./install auto
      EOF

    tags = {
      Name = "Project1-web-server"
      Project1WebsiteServer = "Project1WebsiteServer"
    }
}