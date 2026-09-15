output "github_actions_role_arn"{
    description = "Role ARN to put in the GitHub Actions workflowe (as a repo variable)."
    value       = module.cicd_oidc.role_arn
}