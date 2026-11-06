variable "iam-user-names" {
    type = list(string)
    default = ["shiva", "james", "john"]
    description = "List of IAM user names to create"
}