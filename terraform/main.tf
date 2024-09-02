locals {
  default_tags = {
    description = "Kennys Medium Article"
    terraform   = true
  }
}

data "aws_caller_identity" "current" {}

resource "aws_iam_openid_connect_provider" "github" {
  url = format("https://%s", var.provider_url)
  client_id_list = [
    var.audience,
  ]
  /*
  AWS secures communication with OIDC identity providers (IdPs) using our library 
  of trusted Certificate Authorities (CAs). If your IdP relies on a certificate 
  that isn't signed by one of these trusted CAs, then we secure communication 
  using the thumbprints you specify.
  */
  thumbprint_list = ["d89e3bd43d5d909b47a18977aa9d5ce36cee184c"]
}

# import {
#   to = aws_iam_openid_connect_provider.github
#   id = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${var.provider_url}"
# }

resource "aws_iam_role" "test_role" {
  name = "GitHub-OIDC-role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${var.provider_url}"
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringLike" : {
            "${var.provider_url}:sub" : [
              "repo:Kenny-AngJY/github-oidc-idp-example:*"
            ]
          },
          "StringEquals" : {
            "${var.provider_url}:aud" : "${var.audience}"
          }
        }
      }
    ]
  })
  managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}