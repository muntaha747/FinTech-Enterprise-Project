variable "user_names" {
    description = "List of IAM user names to create"
    type = list(string)
    default = ["shiva", "james", "john"]
}
