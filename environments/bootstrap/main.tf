module "cicd_oidc" {
  source            = "../../modules/cicd-oidc"
  github_repo       = "Mannixgr@76853105/enterprise-hybrid-aws@1298833769"
  oidc_provider_arn = aws_iam_openid_connect_provider.github_actions.arn
}
locals {
  gh_sub_prefix    = "repo:Mannixgr@76853105/enterprise-hybrid-aws@1298833769"
  state_bucket_arn = "arn:aws:s3:::mannix-enterprise-hybrid-aws-tfstate"
  dev_state_key    = "enterprise-hybrid-aws/terraform.tfstate"
}

data "aws_iam_policy_document" "plan_state" {
  statement {
    sid       = "ListStateBucket"
    actions   = ["s3:ListBucket"]
    resources = [local.state_bucket_arn]
  }
  statement {
    sid       = "ReadDevState"
    actions   = ["s3:GetObject"]
    resources = ["${local.state_bucket_arn}/${local.dev_state_key}"]
  }
  statement {
    sid       = "ManageDevLock"
    actions   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = ["${local.state_bucket_arn}/${local.dev_state_key}.tflock"]
  }
  statement {
    sid           = "DenyObjectReadsExceptDevState"
    effect        = "Deny"
    actions       = ["s3:GetObject", "s3:GetObjectVersion"]
    not_resources = ["${local.state_bucket_arn}/${local.dev_state_key}", "${local.state_bucket_arn}/${local.dev_state_key}.tflock"]
  }
}

module "github_plan_role" {
  source             = "../../modules/github-oidc-role"
  role_name          = "github-actions-terraform-plan"
  oidc_provider_arn  = aws_iam_openid_connect_provider.github_actions.arn
  subjects           = ["${local.gh_sub_prefix}:pull_request"]
  policy_arns        = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
  inline_policy_json = data.aws_iam_policy_document.plan_state.json
}

data "aws_iam_policy_document" "apply_state" {
  statement {
    sid       = "ListStateBucket"
    actions   = ["s3:ListBucket"]
    resources = [local.state_bucket_arn]
  }
  statement {
    sid       = "ReadWriteDevState"
    actions   = ["s3:GetObject", "s3:PutObject"]
    resources = ["${local.state_bucket_arn}/${local.dev_state_key}"]
  }
  statement {
    sid       = "ManageDevLock"
    actions   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = ["${local.state_bucket_arn}/${local.dev_state_key}.tflock"]
  }
  statement {
    sid       = "DescribeEipAttributes"
    actions   = ["ec2:DescribeAddressesAttribute"]
    resources = ["*"]
  }
  statement {
    sid       = "ManageDashboards"
    actions   = ["cloudwatch:GetDashboard", "cloudwatch:PutDashboard", "cloudwatch:DeleteDashboards"]
    resources = ["arn:aws:cloudwatch::*:dashboard/enterprise-hybrid-aws-*"]
  }
}

module "github_apply_role" {
  source             = "../../modules/github-oidc-role"
  role_name          = "github-actions-terraform-apply"
  oidc_provider_arn  = aws_iam_openid_connect_provider.github_actions.arn
  subjects           = ["${local.gh_sub_prefix}:environment:dev"]
  policy_arns        = ["arn:aws:iam::aws:policy/AmazonVPCFullAccess"]
  inline_policy_json = data.aws_iam_policy_document.apply_state.json
}
