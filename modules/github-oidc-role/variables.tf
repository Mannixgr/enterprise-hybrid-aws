variable "role_name" {
  description = "Name of the IAM role to create."
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN of the existing GitHub Actions IAM OIDC provider."
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:iam::[0-9]{12}:oidc-provider/.+$", var.oidc_provider_arn))
    error_message = "oidc_provider_arn must be a valid IAM OIDC provider ARN."
  }
}

variable "subjects" {
  description = "Exact OIDC sub claims allowed to assume the role, e.g. repo:<owner@id>/<repo@id>:pull_request."
  type        = list(string)

  validation {
    condition     = length(var.subjects) > 0 && alltrue([for s in var.subjects : !strcontains(s, "*")])
    error_message = "subjects must be non-empty and must not contain wildcards."
  }
}

variable "policy_arns" {
  description = "AWS managed policy ARNs to attach to the role."
  type        = list(string)
  default     = []
}

variable "inline_policy_json" {
  description = "Optional IAM policy JSON attached inline to the role. Null means no inline policy."
  type        = string
  default     = null
}
