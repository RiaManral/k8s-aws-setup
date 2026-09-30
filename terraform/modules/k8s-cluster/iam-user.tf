resource "aws_iam_user" "iam_user" {
  name          = "admin-user"
  force_destroy = true

}

resource "aws_iam_user_policy_attachment" "policy_attachment" {

  user       = aws_iam_user.iam_user.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"

}

resource "aws_iam_access_key" "access_key" {
  user = aws_iam_user.iam_user.name
}

#temporary output for access key and secret access key
# output "iam_user_access_key_id" {
#   value = aws_iam_access_key.access_key.id
# }

output "iam_user_secret_access_key" {
  value     = aws_iam_access_key.access_key.secret
  sensitive = true
}
