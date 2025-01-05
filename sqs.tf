resource "aws_sqs_queue" "this" {
  name = local.name

  visibility_timeout_seconds = var.visibility_timeout_seconds
  message_retention_seconds  = var.message_retention_seconds
  max_message_size           = var.max_message_size
  delay_seconds              = var.delay_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds
  policy                     = data.aws_iam_policy_document.sqs_resource_policy.json

  fifo_queue            = var.is_fifo_queue
  fifo_throughput_limit = var.fifo_throughput_limit

  content_based_deduplication = var.content_based_deduplication
  deduplication_scope         = var.deduplication_scope

  sqs_managed_sse_enabled           = var.kms_master_key_id == null ? true : null
  kms_master_key_id                 = var.kms_master_key_id
  kms_data_key_reuse_period_seconds = var.kms_data_key_reuse_period_seconds

  tags = merge(local.tags, {
    Name = local.name
  })
}

## Here we create the default policy and we also add the root access
## In here we also do a string replacement to add the ARN of itself to the policy. The user needs to use the keywork "$$$self_arn" to ensure this happens
data "aws_iam_policy_document" "source_queue_policy_default" {
  source_policy_documents = [
    replace(var.policy, "$$$self_arn", aws_sqs_queue.this.arn),
    data.aws_iam_policy_document.deny_not_our_organization.json
  ]

  statement {
    sid     = "account_root_access"
    actions = ["sqs:*"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.account}:root"]
    }
    resources = ["*"]
  }
}

resource "aws_sqs_queue_policy" "source_queue" {
  count     = var.attach_default_policy ? 1 : 0
  queue_url = aws_sqs_queue.this.id
  policy    = data.aws_iam_policy_document.source_queue_policy_default.json
}
################################################################################
# Re-drive Policy
################################################################################

resource "aws_sqs_queue_redrive_policy" "this" {
  count = !var.create_dlq && length(var.redrive_policy) > 0 ? 1 : 0

  queue_url      = aws_sqs_queue.this.url
  redrive_policy = jsonencode(var.redrive_policy)
}

resource "aws_sqs_queue_redrive_policy" "dlq" {
  count = var.create_dlq ? 1 : 0

  queue_url = aws_sqs_queue.this.url
  redrive_policy = jsonencode(
    merge(
      {
        deadLetterTargetArn = aws_sqs_queue.dlq[0].arn
        maxReceiveCount     = 5
    }, var.redrive_policy)
  )
}

################################################################################
# Dead Letter Queue
################################################################################

## Here we create the default policy and we also add the root access
## In here we also do a string replacement to add the ARN of itself to the policy. The user needs to use the keywork "$$$self_arn" to ensure this happens
data "aws_iam_policy_document" "deadletter_queue_policy_default" {
  count = var.create_dlq && var.dlq_attach_default_policy ? 1 : 0
  source_policy_documents = [
    data.aws_iam_policy_document.dlq_resource_policy[0].json,
    data.aws_iam_policy_document.deny_not_our_organization.json
  ]

  statement {
    sid     = "account_root_access"
    actions = ["sqs:*"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.account}:root"]
    }
    resources = ["*"]
  }
}

resource "aws_sqs_queue_policy" "deadletter_queue" {
  count     = var.create_dlq && var.dlq_attach_default_policy ? 1 : 0
  queue_url = aws_sqs_queue.dlq[0].id
  policy    = data.aws_iam_policy_document.deadletter_queue_policy_default[0].json
}

resource "aws_sqs_queue" "dlq" {
  count = var.create_dlq ? 1 : 0

  name                        = local.dlq_name
  content_based_deduplication = try(coalesce(var.dlq_content_based_deduplication, var.content_based_deduplication), null)
  deduplication_scope         = try(coalesce(var.dlq_deduplication_scope, var.deduplication_scope), null)
  delay_seconds               = try(coalesce(var.dlq_delay_seconds, var.delay_seconds), null)
  # If source queue is FIFO, DLQ must also be FIFO and vice versa
  fifo_queue                        = var.is_fifo_queue
  fifo_throughput_limit             = var.fifo_throughput_limit
  kms_data_key_reuse_period_seconds = try(coalesce(var.dlq_kms_data_key_reuse_period_seconds, var.kms_data_key_reuse_period_seconds), null)
  kms_master_key_id                 = local.dlq_kms_master_key_id
  max_message_size                  = var.max_message_size
  message_retention_seconds         = try(coalesce(var.dlq_message_retention_seconds, var.message_retention_seconds), null)
  receive_wait_time_seconds         = try(coalesce(var.dlq_receive_wait_time_seconds, var.receive_wait_time_seconds), null)
  sqs_managed_sse_enabled           = local.dlq_kms_master_key_id != null ? null : local.dlq_sqs_managed_sse_enabled
  visibility_timeout_seconds        = try(coalesce(var.dlq_visibility_timeout_seconds, var.visibility_timeout_seconds), null)

  tags = merge(local.tags, { Name = local.dlq_name })
}

################################################################################
# Re-drive Allow Policy
################################################################################

resource "aws_sqs_queue_redrive_allow_policy" "this" {
  count = !var.create_dlq && length(var.redrive_allow_policy) > 0 ? 1 : 0

  queue_url            = aws_sqs_queue.this.url
  redrive_allow_policy = jsonencode(var.redrive_allow_policy)
}

resource "aws_sqs_queue_redrive_allow_policy" "dlq" {
  count = var.create_dlq && length(var.dlq_redrive_allow_policy) > 0 ? 1 : 0

  queue_url = aws_sqs_queue.dlq[0].url
  redrive_allow_policy = jsonencode(
    merge(
      {
        redrivePermission = "byQueue",
        sourceQueueArns   = [aws_sqs_queue.this.arn]
    }, var.dlq_redrive_allow_policy)
  )
}