# Create and configure Github's OpenID connection
resource "aws_iam_openid_connect_provider" "gitOIDC" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]
}
