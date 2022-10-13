/*
*
*      Code Commit Repo Creation
*
*/

resource "aws_codecommit_repository" "repo" {
    repository_name                 = "project1_repo"
    description                     = "Code Repository for Ice Cream Website"
}