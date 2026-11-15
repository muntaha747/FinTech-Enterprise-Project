
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


variable "bucket_name" {
  type    = list(string)
  default = ["muntaha-bucket-0", "muntaha-bucket-1", "muntaha-bucket-2"]
}



variable "bucket_name_set" {
  type    = set(string)
  default = ["muntaha-bucket-0", "muntaha-bucket-1", "muntaha-bucket-2"]
}




variable "servers" {
  description = "Iterating over the servers"
  type = map(object({
    name = number
    instance_type = string,
    env = string,
    tenancy = bool
  }))
  default = { 
    web = {
    name = 1,
    instance_type = "t3.micro",
    env = "dev",
    tenancy = false
  },
    app = {
      name = 2,
      instance_type = "t3.medium",
      env = "qa",
      tenancy = false
    },
    backend = {
      name = 3,
      instance_type = "t3.large",
      env = "stage",
      tenancy = true
    },

    iam = {
      name = 4,
      instance_type = "t2.xlarge",
      env = "prod",
      tenancy = true
    }
}
}

{ for k, v in var.servers : k => v.tenancy}

{for k, v in var.servers : k => v.instance_type}