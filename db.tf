/*
*
*      DB Server Configuration
*
*/

# AWS DB Instance for MySQL DB
resource "aws_db_instance" "rds_instance" {
    allocated_storage       = 20
    instance_class          = var.db_instance_class
    engine                  = "mysql"
    engine_version          = "5.7"
    identifier              = "rds-terraform"
    db_name                 = "IceCream"
    username                = "admin"
    password                = "ProfKettlesLovesDonuts123"
    skip_final_snapshot     = true
    db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
    publicly_accessible     = true
    vpc_security_group_ids  = [aws_security_group.db_sg.id]
    

    tags = {
        Name = "rds-db-server"
    }
}

# AWS DB Subnet Resource
resource "aws_db_subnet_group" "rds_subnet_group" {
    name        = "main"
    description = "Subnet for the DB Instance"
    subnet_ids = [aws_subnet.private.id, aws_subnet.private2.id]

    tags = {
        Name = "db-subnets"
    }
}