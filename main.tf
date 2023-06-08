# --- SSM Parameters ----------------------------------------------------------
resource "aws_ssm_parameter" "parameter" {
  for_each = { for ssm_parameter in var.ssm_parameters : ssm_parameter.name => ssm_parameter.value }

  name  = "/${var.ssm_parameter_name_prefix}/${each.key}"
  type  = "SecureString"
  value = each.value
}

# --- IAM ---------------------------------------------------------------------
data "aws_caller_identity" "current" {}

data "aws_kms_key" "ssm" {
  key_id = "alias/aws/ssm"
}

data "aws_region" "current" {}

data "aws_iam_policy_document" "ssm_parameter_store_access_policy" {
  statement {
    actions = [
      "ssm:DescribeParameters"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters"
    ]
    resources = [
      "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/${var.ssm_parameter_name_prefix}/*"
    ]
  }

  statement {
    actions = [
      "kms:Decrypt"
    ]
    resources = [
      "${data.aws_kms_key.ssm.arn}"
    ]
  }
}

resource "aws_iam_policy" "ssm_parameter_store_access" {
  name        = "${local.snake_case_name}_ssm_parameter_store_access"
  path        = "/"
  description = "${var.name} SSM Parameter Store access"

  policy = data.aws_iam_policy_document.ssm_parameter_store_access_policy.json
}
