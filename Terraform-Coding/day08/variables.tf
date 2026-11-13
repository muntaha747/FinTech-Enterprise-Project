
################################ Object (Dictionary) ################################
variable "config_values" {
  type = object({
    region         = string
    monitoring     = bool
    instance_count = number
    instance_type  = string
  })
  default = {
    region         = "us-east-1"
    monitoring     = true
    instance_count = 3
    instance_type  = "t3.micro"
  }
}

variable "ingress_values" {
  type    = tuple([number, string, number])
  default = [22, "tcp", 443]
}

