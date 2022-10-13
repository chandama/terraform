variable "ami" {
  type = string
  default = "ami-0f924dc71d44d23e2"
}
variable "region" {
  type = string
  default = "us-east-2"  
}
variable "availability_zone" {
  type = string
  default = "us-east-2a"  
}
variable "instance_type" {
  type = string
  default = "t2.small"
}
variable "db_instance_class" {
  type = string
  default = "db.t3.micro"
}