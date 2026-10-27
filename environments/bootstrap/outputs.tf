
output "plan_role_arn" {
  description = "Read-only role for PR plans (repo variable AWS_PLAN_ROLE_ARN)."
  value       = module.github_plan_role.role_arn
}

output "apply_role_arn" {
  description = "Apply role, assumable only from the GitHub 'dev' environment (repo variable AWS_APPLY_ROLE_ARN)."
  value       = module.github_apply_role.role_arn
}

output "cloudguard_role_arn" {
  description = "Cloudguard role, used for scanning through aws"
  value       = aws_iam_role.cloudguard_readonly.arn
}