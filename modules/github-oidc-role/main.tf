# Trust policy: only the exact GitHub OIDC subjects passed in may assume this role.
data "aws_iam_policy_document" "github_oidc_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = var.subjects
    }
  }
}

resource "aws_iam_role" "this" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.github_oidc_trust.json
}

# Attach any specified AWS managed policies to the role.
resource "aws_iam_role_policy_attachment" "this" {
  for_each   = toset(var.policy_arns)
  role       = aws_iam_role.this.name
  policy_arn = each.value
}

# Optional inline policy (e.g. scoped Terraform state access).
resource "aws_iam_role_policy" "this" {
  count  = var.inline_policy_json == null ? 0 : 1
  name   = "${var.role_name}-inline"
  role   = aws_iam_role.this.id
  policy = var.inline_policy_json
}
