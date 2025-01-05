## Don't call tag module from a module. Call it from Workspace only.
## Remember that tag key that comes later will override previous same key.
## The TFModule will be the full path of how this module was called. 
locals {
  region  = data.aws_region.current.name
  account = data.aws_caller_identity.current.id
  org_id  = data.aws_organizations_organization.this.id
  name    = var.sqs_name_override == true ? var.name : join("-", [var.name, local.region])

  tags = merge(var.tags,
    {
      Name     = var.name,
      TFModule = basename(path.module)
    }
  )
  ################################################################################
  # Dead Letter Queue
  ################################################################################

  stripped_dlq_name           = try(trimsuffix(var.dlq_name, ".fifo"), "")
  inter_dlq_name              = try(coalesce(local.stripped_dlq_name, "${local.name}-dlq"), "")
  dlq_name                    = var.is_fifo_queue ? "${local.inter_dlq_name}.fifo" : local.inter_dlq_name
  dlq_kms_master_key_id       = try(coalesce(var.dlq_kms_master_key_id, var.kms_master_key_id), null)
  dlq_sqs_managed_sse_enabled = coalesce(var.dlq_kms_master_key_id, var.kms_master_key_id, true)

  ################################################################################
  # CloudWatch Alarm
  ################################################################################
  queue_name_for_alarm = var.create_dlq ? local.dlq_name : local.name
  alarm_name           = "${local.name}-dlq-alarm"
  sns_topic_name       = "${local.name}-dlq-notification"
  aws_managed_kms_key  = "alias/aws/sns"
  alarm_description    = "SQS Queue Metrics: ${local.name}"
  lambda_susbscribers  = length(var.alarm_sns_topic_subscribers) == 0 ? {} : { for k, v in var.alarm_sns_topic_subscribers : k => v if v.protocol == "lambda" }
}