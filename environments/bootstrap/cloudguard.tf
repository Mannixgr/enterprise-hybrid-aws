variable "cloudguard_username" {
  type        = string
  default     = "Mannix"
  description = "The IAM username authorized to assume the scanner role."
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "cloudguard_trust" {

  statement {
    sid     = "AllowCloudguardAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${var.cloudguard_username}"]
    }
    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
  }
}

resource "aws_iam_role" "cloudguard_readonly" {
  name               = "cloudguard-readonly"
  assume_role_policy = data.aws_iam_policy_document.cloudguard_trust.json

  tags = {
    Purpose = "cloudguard-scanning"
  }
}

locals {
  managed_policies = [
    "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"
    , "arn:aws:iam::aws:policy/SecurityAudit"
  ]
}
resource "aws_iam_role_policy_attachment" "cloudguard_attachments" {
  for_each   = toset(local.managed_policies)
  role       = aws_iam_role.cloudguard_readonly.name
  policy_arn = each.value
}

data "aws_iam_policy_document" "cloudguard_inline_deny" {
  statement {
    sid       = "DenystateObjectsReads"
    effect    = "Deny"
    actions   = ["s3:GetObject", "s3:GetObjectVersion"]
    resources = ["${local.state_bucket_arn}/*"]
  }
}
resource "aws_iam_role_policy" "cloudguard_deny_state" {
  name   = "cloudguard-deny-state-access"
  role   = aws_iam_role.cloudguard_readonly.id
  policy = data.aws_iam_policy_document.cloudguard_inline_deny.json
}