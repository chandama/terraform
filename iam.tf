/*
*
*      IAM Configuration for EC2 Instance
*
*/

# IAM Assume Role for EC2
resource "aws_iam_role" "ec2_instance_role" {
  name                      = "EC2InstanceRole"
  description               = "IAM Role for access EC2"
  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  }
  EOF

  tags = {
    Name = "EC2AssumeRole"
  }
}

# EC2 Instance Profile to be referenced by aws_instance resource
resource "aws_iam_instance_profile" "ec2_profile" {
  name                      = "ec2_profile"
  role                      = aws_iam_role.ec2_instance_role.name
}

# Attach role policies for SSMManagedInstanceCore and S3ReadOnlyAccess to EC2 Instance
resource "aws_iam_role_policy_attachment" "role_policy_attachment" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  ])

  role = aws_iam_role.ec2_instance_role.name
  policy_arn = each.value
}


/*
*
*      IAM Configuration for Code Deploy
*
*/

# IAM role for CodeDeploy
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_deployment_group
resource "aws_iam_role" "code_deploy_role" {
  name = "CodeDeployRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Attach AWSCodeDeployRole Permissions to CodeDeployRole above
resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = aws_iam_role.code_deploy_role.name
}



resource "aws_iam_policy" "EC2CodeDeploy" {
  name                      = "EC2CodeDeployPolicy"
  description               = "Code Deploy Policy for AWS"
  policy = jsonencode({
      "Statement": [
          {
              "Action": [
                  "s3:GetObject",
                  "s3:GetObjectVersion",
                  "s3:PutObject",
                  "s3:ListBucket"
              ],
              "Effect": "Allow",
              "Resource": "*"
          }
      ],
      "Version": "2012-10-17"
  })
}

# Attach CodeDeploy Policy to EC2 Role
resource "aws_iam_policy_attachment" "ec2" {
  name                      = "EC2PolicyAttachment"
  roles                     = [aws_iam_role.ec2_instance_role.name]
  policy_arn                = aws_iam_policy.EC2CodeDeploy.arn
}




resource "aws_iam_role" "codepipeline_role" {
  name = "test-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "codepipeline_policy"
  role = aws_iam_role.codepipeline_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning",
        "s3:PutObjectAcl",
        "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.codepipeline_bucket.arn}",
        "${aws_s3_bucket.codepipeline_bucket.arn}/*"
      ]
    },
    {
    "Effect": "Allow",
    "Action": [  
        "codecommit:GetBranch",
        "codecommit:GetCommit",
        "codecommit:UploadArchive",
        "codecommit:GetUploadArchiveStatus",      
        "codecommit:CancelUploadArchive",
        "codedeploy:CreateDeployment",
        "codedeploy:GetDeployment",
        "codedeploy:GetDeploymentConfig",
        "codedeploy:RegisterApplicationRevision",
        "codedeploy:*"
                ],
    "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}