variable "environment" {
  type    = string
  #default = "Dev"
}

variable "region" {
  #default = "us-east-1"
  type    = string
}

variable "vpc_name" {
  #default = "my-vpc-muntaha"
  type    = string
}

variable "amiid" {
  #default = "ami-09bf9dfeeb1e9adbc"
  type    = string
}

variable "instance_type" {
  type    = string
  #default = "t2.micro"
}

variable "channel_name" {
  type    = string
  #default = "muntaha-tv"
}

variable "bucket_name" {
  type    = string
  #default = "muntaha-tech-bucket"
}

variable "cidr_block" {
    type = string
   #default = "10.0.0.0/16"
}