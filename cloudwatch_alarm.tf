resource "aws_cloudwatch_metric_alarm" "dlq" {
  count = var.create_alarm ? 1 : 0

  alarm_name        = local.alarm_name
  alarm_description = "Alerts subscriber(s) when a new message is added to the ${local.queue_name_for_alarm} queue."
  namespace         = "AWS/SQS"
  metric_name       = "NumberOfMessagesSent"
  dimensions = {
    QueueName = var.create_dlq ? local.dlq_name : local.name
  }
  statistic           = "Sum"
  period              = var.alarm_period
  comparison_operator = "GreaterThanThreshold"
  threshold           = 0

  evaluation_periods = var.alarm_evaluation_period
  treat_missing_data = "notBreaching"
  alarm_actions      = [module.alarm_dlq_sns_topic[0].sns_topic_arn]

  tags = merge(local.tags, { "Name" = "${var.create_dlq ? local.dlq_name : local.name}-alarm" })
}