variable "instance_type" {
  description = "Type of the instance"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  default = "ami-0d97d7f07b25dd693"
}