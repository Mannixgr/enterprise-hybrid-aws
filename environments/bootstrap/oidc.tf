# Fetches GitHub's OIDC certificate dynamically instead of hardcoding the thumbprint.
data "tls_certificate" "github_actions" {
  url = "https://token.actions.githubusercontent.com"
}

# Registers GitHub Actions as a trusted OIDC identity provider.
# Lives at the root so every CI role (old, plan, apply) can share it.
resource "aws_iam_openid_connect_provider" "github_actions" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.github_actions.certificates[0].sha1_fingerprint]
}