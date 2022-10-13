output "s3_bucket_id" {
    value = aws_instance.project1_ec2_webserver.public_ip
}
output "rds_name" {
    value = aws_db_instance.rds_instance.endpoint
}
