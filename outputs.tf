output "sqs_queue_id" {
  description = "The URL for the created Amazon SQS queue"
  value       = aws_sqs_queue.this.id
}

output "sqs_queue_arn" {
  description = "The ARN of the SQS queue"
  value       = aws_sqs_queue.this.arn
}

output "sqs_queue_name" {
  description = "The ARN of the SQS queue"
  value       = aws_sqs_queue.this.name
}

output "deadletter_queue_arn" {
  value       = one(aws_sqs_queue.dlq.*.arn)
  description = "the arn of the deadletter queue"
}

output "deadletter_queue_id" {
  description = "The URL for the created Amazon SQS queue"
  value       = one(aws_sqs_queue.dlq.*.id)
}

output "kms_key_id" {
  description = "the id of the custom kms key created by this module"
  value       = one(module.sns_kms_key.*.key_id)
}

output "kms_key_arn" {
  description = "the arn of the custom kms key created by this module"
  value       = one(module.sns_kms_key.*.key_arn)
}

output "kms_key_alias" {
  description = "the alias of the custom kms key created by this module"
  value       = one(module.sns_kms_key.*.alias)
}

output "alarm_sns_topic_arn" {
  description = "the sns topic arn when a cloudwatch alarm is created"
  value       = one(module.alarm_dlq_sns_topic.*.sns_topic_arn)
}