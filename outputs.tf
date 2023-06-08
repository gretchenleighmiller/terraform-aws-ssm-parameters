output "ssm_parameter_store_access_policy" {
  value = {
    name = aws_iam_policy.ssm_parameter_store_access.name
    arn  = aws_iam_policy.ssm_parameter_store_access.arn
  }
  description = "The name and ARN of the IAM policy to access the SSM Parameters."
}
