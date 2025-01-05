## This is the SNS topic that will be called by the cloudwatch alarm when a message is put on the dead letter queue. 
## https://github.com/quickmute/terraform-aws-mod-sns
module "alarm_dlq_sns_topic" {
  source  = "app.terraform.io/embshd/mod-sns/aws"
  version = ">= 1.0.0, < 2.0.0"

  count = var.create_alarm ? 1 : 0

  sns_topic_name   = local.sns_topic_name
  sns_display_name = var.alarm_sns_topic_display_name
  #sns_topic_policy                = length(var.alarm_sns_topic_policy) == 0 ? data.aws_iam_policy_document.default_sns_resource_policy[0].json : var.dlq_policy
  org_access                      = var.alarm_sns_org_access
  self_access                     = var.alarm_sns_self_access
  kms_master_key_id               = !var.create_alarm_sns_kms_key ? coalesce(var.alarm_sns_kms_key_id, local.aws_managed_kms_key) : module.sns_kms_key[0].key_arn
  include_failed_delivery_logging = var.alarm_sns_include_failed_delivery_logging
  publish_from_cloudwatch         = true
  tags                            = merge(local.tags, { Name = local.sns_topic_name })
}

resource "aws_sns_topic_subscription" "default" {
  for_each = var.alarm_sns_topic_subscribers

  topic_arn              = one(module.alarm_dlq_sns_topic.*.sns_topic_arn)
  protocol               = var.alarm_sns_topic_subscribers[each.key].protocol
  endpoint               = var.alarm_sns_topic_subscribers[each.key].endpoint
  endpoint_auto_confirms = var.alarm_sns_topic_subscribers[each.key].endpoint_auto_confirms
  raw_message_delivery   = var.alarm_sns_topic_subscribers[each.key].raw_message_delivery
  depends_on = [
    module.alarm_dlq_sns_topic
  ]
}

resource "aws_lambda_permission" "this" {
  for_each = local.lambda_susbscribers

  action        = "lambda:InvokeFunction"
  statement_id  = "AllowExecutionFromSNS"
  principal     = "sns.amazonaws.com"
  source_arn    = one(module.alarm_dlq_sns_topic.*.sns_topic_arn)
  function_name = each.value.endpoint
}