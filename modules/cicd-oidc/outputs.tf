output "role_arn"{
    description = "ARN of the IAM role GitHub Actions assumes VIA OIDC."
    value = aws_iam_role.github_actions_terraform.arn
}