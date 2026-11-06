variable "instance_id" {
    description = "ID of the instance to associate with the EIP"
    type        = string
} # We are not giving the default variable because we want to pass during the tf apply time like tf plan or apply -var="instance_id=<instance_id>"
