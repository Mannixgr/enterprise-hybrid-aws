variable "github_repo" {
  description = "GitHub OIDC subject prefix allowed to assume the role (immutable form: owner@id/repo@id)."
  type        = string
}

variable "role_name" {
  description = "Name of the IAM role GitHub Actions will use via OIDC."
  type        = string
  default     = "github-actions-terraform"
}

variable "oidc_provider_arn" {
  description = "ARN of the IAM OIDC provider used for federation."
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:iam::[0-9]{12}:oidc-provider/.+$", var.oidc_provider_arn))
    error_message = "oidc_provider_arn must be a valid IAM OIDC provider ARN, e.g. arn:aws:iam::123456789012:oidc-provider/token.actions.githubusercontent.com."
  }
}
