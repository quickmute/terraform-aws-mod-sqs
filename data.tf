data "aws_organizations_organization" "this" {}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_iam_policy_document" "sqs_resource_policy" {
  source_policy_documents = [var.policy]
  statement {
    sid    = "EnforceIdentityPerimeter"
    effect = "Deny"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = ["sqs:*"]
    condition {
      test     = "StringNotEqualsIfExists"
      variable = "aws:PrincipalOrgId"
      values   = [data.aws_organizations_organization.this.id]
    }
    condition {
      test     = "BoolIfExists"
      variable = "aws:PrincipalIsAWSService"
      values   = ["false"]
    }
  }
  statement {
    sid    = "DenyUnsecureTransport"
    effect = "Deny"
    actions = [
      "sqs:ReceiveMessage",
      "sqs:SendMessage"
    ]
    resources = ["*"]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

data "aws_iam_policy_document" "default_sns_resource_policy" {
  count = length(var.alarm_sns_topic_policy) == 0 ? 1 : 0

  statement {
    sid    = "AllowPublishForAlarm"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudwatch.amazonaws.com"]
    }
    actions   = ["sns:Publish"]
    resources = ["arn:aws:cloudwatch:${local.region}:${local.account}:${local.sns_topic_name}"]
  }
}

data "aws_iam_policy_document" "dlq_resource_policy" {
  count = var.create_dlq ? 1 : 0

  source_policy_documents = [var.dlq_policy]
  statement {
    sid    = "AllowSqsSendMessageToDeadletter"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["sqs.amazonaws.com"]
    }
    actions   = ["SQS:SendMessage"]
    resources = ["arn:aws:sqs:${local.region}:${local.account}:${local.dlq_name}"]
    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [aws_sqs_queue.this.arn]
    }
  }
}

## This is default policy that denies access outside of our organization with exception being Service access.
data "aws_iam_policy_document" "deny_not_our_organization" {
  statement {
    sid     = "EnforceIdentityPerimeter"
    effect  = "Deny"
    actions = ["sqs:*"]

    condition {
      test     = "StringNotEqualsIfExists"
      variable = "aws:ResourceOrgID"
      values   = [local.org_id]
    }

    condition {
      test     = "BoolIfExists"
      variable = "aws:PrincipalIsAWSService"
      values   = ["false"]
    }

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}

data "aws_iam_policy_document" "kms_access_policy" {
  count = var.create_alarm_sns_kms_key ? 1 : 0

  statement {
    sid = "CloudWatchKmsPermissions"
    actions = [
      "kms:GenerateDataKey*",
      "kms:Decrypt",
      "kms:Encrypt"
    ]
    principals {
      type        = "Service"
      identifiers = ["cloudwatch.amazonaws.com"]
    }
    resources = ["$$$self_arn"]
  }
}