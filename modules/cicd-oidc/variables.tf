variable "github_repo" {
    description = "GitHub repo allowed to assume the role, as\"owner/repo\"."
    type = string 
}
variable "role_name"{
    description = " Name of the IAM role GitHub Actions will use via OIDC."
    type = string 
    default = "github-actions-terraform" 
}