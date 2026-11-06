# resource "aws_iam_user" "this" {
#   for_each = toset(var.user_names)
#   name     = each.value
# }

resource "aws_iam_user" "iam-user" {
  count = length(var.user_names)
  name     = var.user_names[count.index]
}