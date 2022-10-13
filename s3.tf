/*
*
*      S3 Bucket Configuration
*
*/

# S3 Bucket for storing web images
resource "aws_s3_bucket" "web_assets" {
  bucket                    = "s3-web-assets"

  tags = {
    Name = "web-assets-bucket"
  }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket                    = aws_s3_bucket.web_assets.bucket
  acl                       = "private"
}

# Put object in bucket. Not being used currrently but will use for objects later if needed
resource "aws_s3_bucket_object" "object1" {
  for_each = fileset("html/", "*")
  bucket = aws_s3_bucket.web_assets.id
  key = each.value
  source = "html/${each.value}"
  etag = filemd5("html/${each.value}")
  content_type = "text/html"
}


# S3 Bucket and ACL for the CodePipeline Artifacts
resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "project1-codepipeline-bucket"
}

resource "aws_s3_bucket_acl" "codepipeline_bucket_acl" {
  bucket = aws_s3_bucket.codepipeline_bucket.id
  acl    = "private"
}