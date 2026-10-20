output "role_arn" {
  description = "The Amazon Resource Name (ARN) of the created IAM role."
  value       = aws_iam_role.this.arn
}

output "role_name" {
  description = "The name of the created IAM role."
  value       = aws_iam_role.this.name
}
