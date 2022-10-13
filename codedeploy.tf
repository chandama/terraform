/*
*
*      Code Deploy Configuration
*
*/

resource "aws_codedeploy_app" "ice_cream_app" {
  name = "ice_cream_app"
  compute_platform = "Server"
}

resource "aws_codedeploy_deployment_group" "deployment-group" {
  app_name = aws_codedeploy_app.ice_cream_app.name
  deployment_group_name = "IceCreamDeploymentGroup"
  deployment_config_name = "CodeDeployDefault.OneAtATime"
  service_role_arn = aws_iam_role.code_deploy_role.arn

  ec2_tag_filter {
    key = "Project1WebsiteServer"
    type = "KEY_ONLY"
  }
  
  deployment_style {
    deployment_type = "IN_PLACE"
  }
}