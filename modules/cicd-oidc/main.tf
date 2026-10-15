# IAM role GitHub Actions assumes via OIDC, with a trust policy scoped to this repo.
resource "aws_iam_role" "github_actions_terraform" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Federated = var.oidc_provider_arn }
      Action    = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
        }
        StringLike = {
          "token.actions.githubusercontent.com:sub" = "repo:${var.github_repo}:*"
        }
      }
    }]
  })
}

# Read/write access to Terraform state in the existing S3 bucket.
resource "aws_iam_role_policy" "terraform_state" {
  name = "terraform-state-access"
  role = aws_iam_role.github_actions_terraform.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject", "s3:ListBucket"]
        Resource = [
          "arn:aws:s3:::mannix-enterprise-hybrid-aws-tfstate",
          "arn:aws:s3:::mannix-enterprise-hybrid-aws-tfstate/*"
        ]
      },
      {
        Effect   = "Allow"
        Action   = ["ec2:DescribeAddressesAttribute"]
        Resource = "*"
      }
    ]
  })
}

# Permission to manage VPC resources using an AWS managed policy.
resource "aws_iam_role_policy_attachment" "network_permissions" {
  role       = aws_iam_role.github_actions_terraform.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
}
