/*
https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services
The values for "provider_url" & "audience" is different for GitHub.
Whereas for GitLab, they are the same. 
*/

variable "provider_url" {
  description = <<EOT
    Omit the "https://" here as it will be appended as the prefix where it is required.
  EOT
  type        = string
  default     = "token.actions.githubusercontent.com"
}

variable "audience" {
  description = <<EOT
    Use the default value define below if you're using the "aws-actions/configure-aws-credentials@v4"
  EOT
  type        = string
  default     = "sts.amazonaws.com"
}