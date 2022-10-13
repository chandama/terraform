/*
*
*      Code Pipeline Configuration
*
*/

resource "aws_codepipeline" "pipeline" {
    name                        = "Project1CodePipeline"
    role_arn                    = aws_iam_role.codepipeline_role.arn

    artifact_store {
      location  = aws_s3_bucket.codepipeline_bucket.bucket
      type      = "S3"
    }

    stage {
      name = "Source"
      
      action {
        name                = "Source"
        category            = "Source"
        owner               = "AWS"
        provider            = "CodeCommit"
        output_artifacts    = ["source_output"]
        version             = "1"

        configuration = {
          RepositoryName = aws_codecommit_repository.repo.repository_name
          BranchName       = "main"
        }
      }
    }

    stage {
      name = "Deploy"

      action {
        name = "Deploy"
        category = "Deploy"
        owner = "AWS"
        provider = "CodeDeploy"
        version = "1"
        input_artifacts = ["source_output"]

        configuration = {
          ApplicationName = aws_codedeploy_app.ice_cream_app.name
          DeploymentGroupName = aws_codedeploy_deployment_group.deployment-group.deployment_group_name
        }
      } 
    }

}
