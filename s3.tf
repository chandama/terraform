/*
*
*      S3 Bucket Configuration
*
*/

# S3 Bucket for storing web images
resource "aws_s3_bucket" "web_assets" {
  bucket                    = "s3-web-assets-${random_id.id.hex}"

  tags = {
    Name = "web-assets-bucket"
  }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket                    = aws_s3_bucket.web_assets.bucket
  acl                       = "public-read"
}

# Put object in bucket. Not being used currrently but will use for objects later if needed
resource "aws_s3_bucket_object" "object1" {
  for_each = fileset("images/", "*")
  bucket = aws_s3_bucket.web_assets.id
  key = each.value
  source = "images/${each.value}"
  etag = filemd5("images/${each.value}")
  content_type = "image/png"
}


# S3 Bucket and ACL for the CodePipeline Artifacts
resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "codepipeline-${random_id.id.hex}"

  tags = {
    Name = "CodePipeline Artefacts"
  }
}

resource "aws_s3_bucket_acl" "codepipeline_bucket_acl" {
  bucket = aws_s3_bucket.codepipeline_bucket.id
  acl    = "private"
}
