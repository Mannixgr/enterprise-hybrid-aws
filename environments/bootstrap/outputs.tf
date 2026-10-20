output "github_actions_role_arn" {
  description = "Legacy CI role ARN (repo variable AWS_ROLE_ARN). Remove after cutover to plan/apply roles."
  value       = module.cicd_oidc.role_arn
}

output "plan_role_arn" {
  description = "Read-only role for PR plans (repo variable AWS_PLAN_ROLE_ARN)."
  value       = module.github_plan_role.role_arn
}

output "apply_role_arn" {
  description = "Apply role, assumable only from the GitHub 'dev' environment (repo variable AWS_APPLY_ROLE_ARN)."
  value       = module.github_apply_role.role_arn
}
