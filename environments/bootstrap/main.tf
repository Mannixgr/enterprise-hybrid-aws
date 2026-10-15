module "cicd_oidc" {
  source            = "../../modules/cicd-oidc"
  github_repo       = "Mannixgr@76853105/enterprise-hybrid-aws@1298833769"
  oidc_provider_arn = aws_iam_openid_connect_provider.github_actions.arn
}
