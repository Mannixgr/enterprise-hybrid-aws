#makes fetching github certifications dynamic instead of hard coded. 
data "tls_certificate" "github_actions" {
    url = "https://token.actions.githubusercontent.com"
}
#this block of code registers github as a trusted OIDC issue. 
resource "aws_iam_openid_connect_provider" "github_actions"{
    url = "https://token.actions.githubusercontent.com"
    client_id_list = ["sts.amazonaws.com"]
    thumbprint_list = [data.tls_certificate.github_actions.certificates[0].sha1_fingerprint]
}
#security block the IAM role with a trust policy

resource "aws_iam_role" "github_actions_terraform" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Federated = aws_iam_openid_connect_provider.github_actions.arn }
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

#will giver permission to read/write Terraform state in existing S3 Buckets 
resource "aws_iam_role_policy"  "terraform_state" {
    name = "terraform-state-access"
    role = aws_iam_role.github_actions_terraform.name
    
    policy = jsonencode ({
        Version ="2012-10-17"
        Statement = [{
            Effect = "Allow"
            Action = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject", "s3:ListBucket"]
            Resource = [
                "arn:aws:s3:::mannix-enterprise-hybrid-aws-tfstate",
                "arn:aws:s3:::mannix-enterprise-hybrid-aws-tfstate/*"

            ]
        },
        {
            Effect = "Allow"
            Action = ["ec2:DescribeAddressesAttribute"]
            Resource = "*"
        }]
    })
}
#permison to manage VPC resources using an aws managed policy. 
resource "aws_iam_role_policy_attachment" "network_permissions"{
    role = aws_iam_role.github_actions_terraform.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"

}
    

