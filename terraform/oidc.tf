# Create and configure Github's OpenID connection
resource "aws_iam_openid_connect_provider" "gitOIDC" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]
  thumbprint_list = ["2b18947a6a9fc7764fd8b5fb18a863b0c6dac24f"]
}
