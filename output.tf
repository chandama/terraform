output "s3_bucket_id" {
    value = aws_instance.project1_ec2_webserver.public_ip
}