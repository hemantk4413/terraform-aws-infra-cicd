resource "aws_iam_user" "terraform_user" {
  name = var.user_name
  path = "/system/"

  tags = {
    tag-key = "prod user name"
    description = "new Iam username- ${var.user_name}"
  }
}
resource "aws_iam_group" "developers" {
  path = "/users/"
  name =var.group_name

}
resource "aws_iam_user_group_membership" "add-user-to-group" {
  user = aws_iam_user.terraform_user.name

  groups = [
    aws_iam_group.developers.name
  ]
}