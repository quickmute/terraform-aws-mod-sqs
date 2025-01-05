
###############################################################
## SQS Queue ##################################################
###############################################################

variable "name" {
  description = "(Required) This is the human-readable name of the queue. If omitted, Terraform will assign a random name."
  type        = string
}

variable "sqs_name_override" {
  description = "(Optional) If you set this to true then we won't add region to the name"
  type        = bool
  default     = false
}

variable "visibility_timeout_seconds" {
  description = "(Optional) The visibility timeout for the queue. An integer from 0 to 43200 (12 hours)"
  type        = number
  default     = 30
}

variable "message_retention_seconds" {
  description = "(Optional) The number of seconds Amazon SQS retains a message. Integer representing seconds, from 60 (1 minute) to 1209600 (14 days)"
  type        = number
  default     = 345600
}

variable "max_message_size" {
  description = "(Optional) The limit of how many bytes a message can contain before Amazon SQS rejects it. An integer from 1024 bytes (1 KiB) up to 262144 bytes (256 KiB)"
  type        = number
  default     = 262144
}

variable "delay_seconds" {
  description = "(Optional) The time in seconds that the delivery of all messages in the queue will be delayed. An integer from 0 to 900 (15 minutes)"
  type        = number
  default     = 0
}

variable "receive_wait_time_seconds" {
  description = "(Optional) The time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning. An integer from 0 to 20 (seconds)"
  type        = number
  default     = 0
}

variable "policy" {
  description = "(Optional) The JSON policy for the SQS queue that will be merged into a default resource policy."
  type        = string
  default     = ""
}

variable "attach_default_policy" {
  description = "(Optional) Defaults to 'true' for attaching a default policy, but you can override with 'false' if you don't want a default policy -- though you should still attach your own policy."
  type        = bool
  default     = true
}

variable "queue_source_policy_documents" {
  description = "(Optional) List of IAM policy documents that are merged together into the exported document. Statements must have unique `sid`s"
  type        = list(string)
  default     = []
}

variable "redrive_policy" {
  description = "(Optional) The JSON policy to set up the Dead Letter Queue, see AWS docs. Note: when specifying maxReceiveCount, you must specify it as an integer (5), and not a string (\"5\")"
  type        = any
  default     = {}
}

variable "redrive_allow_policy" {
  description = "(Optional) The JSON policy to set up the Dead Letter Queue redrive permission, see AWS docs."
  type        = any
  default     = {}
}

variable "is_fifo_queue" {
  description = "(Optional) Boolean designating a FIFO queue. If not set, it defaults to false making it standard."
  type        = bool
  default     = false
}

variable "content_based_deduplication" {
  description = "(Optional) Enables content-based deduplication for FIFO queues"
  type        = bool
  default     = false
}

variable "kms_master_key_id" {
  description = "(Optional) The ID of an AWS-managed customer master key (CMK) for Amazon SQS or a custom CMK"
  type        = string
  default     = null
}

variable "kms_data_key_reuse_period_seconds" {
  description = "(Optional) The length of time, in seconds, for which Amazon SQS can reuse a data key to encrypt or decrypt messages before calling AWS KMS again. An integer representing seconds, between 60 seconds (1 minute) and 86,400 seconds (24 hours)"
  type        = number
  default     = null
}

variable "deduplication_scope" {
  description = "(Optional) The length of time, in seconds, for which Amazon SQS can reuse a data key to encrypt or decrypt messages before calling AWS KMS again. An integer representing seconds, between 60 seconds (1 minute) and 86,400 seconds (24 hours)"
  type        = string
  default     = null
  validation {
    condition = (
      var.deduplication_scope == "messageGroup" ||
      var.deduplication_scope == "queue" ||
      var.deduplication_scope == null
    )
    error_message = "Deduplication scope must be either queue (Default) or messageGroup"
  }
}

variable "fifo_throughput_limit" {
  description = "(Optional) Specifies whether the FIFO queue throughput quota applies to the entire queue or per message group"
  type        = string
  default     = null
  validation {
    condition = (
      var.fifo_throughput_limit == "perQueue" ||
      var.fifo_throughput_limit == "perMessageGroupId" ||
      var.fifo_throughput_limit == null
    )
    error_message = "fifo throughput limit must be either perQueue (Default) or perMessageGroupId"
  }
}

variable "tags" {
  description = "(Required) A mapping of tags to assign to all resources"
  type        = map(string)
}

################################################################################
# Dead Letter Queue
################################################################################

variable "create_dlq" {
  description = "(Optional) Determines whether to create SQS dead letter queue"
  type        = bool
  default     = false
}

variable "dlq_name" {
  description = "(Optional) This is the human-readable name of the deadletter queue. If omitted, Terraform will assign a random name. if you are using an existing deadletter queue input that name here."
  type        = string
  default     = null
}

variable "dlq_content_based_deduplication" {
  description = "(Optional) Enables content-based deduplication for FIFO queues"
  type        = bool
  default     = null
}

variable "dlq_deduplication_scope" {
  description = "(Optional) Specifies whether message deduplication occurs at the message group or queue level"
  type        = string
  default     = null
}

variable "dlq_delay_seconds" {
  description = "(Optional) The time in seconds that the delivery of all messages in the queue will be delayed. An integer from 0 to 900 (15 minutes)"
  type        = number
  default     = 0
}

variable "dlq_kms_data_key_reuse_period_seconds" {
  description = "(Optional) The length of time, in seconds, for which Amazon SQS can reuse a data key to encrypt or decrypt messages before calling AWS KMS again. An integer representing seconds, between 60 seconds (1 minute) and 86,400 seconds (24 hours)"
  type        = number
  default     = 300
}

variable "dlq_kms_master_key_id" {
  description = "(Optional) The ID of an AWS-managed customer master key (CMK) for Amazon SQS or a custom CMK"
  type        = string
  default     = null
}

variable "dlq_message_retention_seconds" {
  description = "(Optional) The number of seconds Amazon SQS retains a message. Integer representing seconds, from 60 (1 minute) to 1209600 (14 days)"
  type        = number
  default     = null
}

variable "dlq_receive_wait_time_seconds" {
  description = "(Optional) The time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning. An integer from 0 to 20 (seconds)"
  type        = number
  default     = 0
}

variable "dlq_redrive_allow_policy" {
  description = "(Optional) The JSON policy to set up the Dead Letter Queue redrive permission, see AWS docs."
  type        = any
  default     = {}
}

variable "dlq_sqs_managed_sse_enabled" {
  description = "(Optional) Boolean to enable server-side encryption (SSE) of message content with SQS-owned encryption keys"
  type        = bool
  default     = true
}

variable "dlq_visibility_timeout_seconds" {
  description = "(Optional) The visibility timeout for the queue. An integer from 0 to 43200 (12 hours)"
  type        = number
  default     = null
}

variable "dlq_attach_default_policy" {
  description = "(Optional) Defaults to 'true' for attaching a default policy, but you can override with 'false' if you don't want a default policy -- though you should still attach your own policy."
  type        = bool
  default     = true
}

variable "dlq_policy" {
  description = "(Optional) The JSON policy for the dlq"
  type        = string
  default     = ""
}

variable "dlq_source_policy_documents" {
  description = "(Optional) List of IAM policy documents that are merged together into the exported document. Statements must have unique `sid`s"
  type        = list(string)
  default     = []
}

###############################################################
## Cloudwatch Alarm ###########################################
###############################################################

variable "create_alarm" {
  description = "(Optional) whether to create a cloudwatch metric alarm when the deadletter queue contains greater than n messages."
  type        = string
  default     = false
}

variable "alarm_period" {
  description = "(Optional) The period in seconds over which the specified statistic is applied."
  type        = number
  default     = 60
}

variable "alarm_evaluation_period" {
  description = "(Optional) The number of periods over which data is compared to the specified threshold."
  type        = number
  default     = 1
}

variable "alarm_threshold" {
  description = "(Optional) The value against which the specified statistic is compared. This parameter is required for alarms based on static thresholds, but should not be used for alarms based on anomaly detection models."
  type        = number
  default     = 0
}

variable "alarm_sns_topic_name" {
  description = "(Optional) The name for the SNS topic."
  type        = string
  default     = null
}

variable "alarm_sns_topic_display_name" {
  description = "(Optional) The display name of the topic. This is what shows when you receive email from this topic. Cannot be longer than 100 characters or contain dots."
  type        = string
  default     = null
}

variable "alarm_sns_include_failed_delivery_logging" {
  description = "(Optional) Should failed message delivery be logged to CloudWatch? Defaults to false"
  type        = bool
  default     = false
}

variable "create_alarm_sns_kms_key" {
  description = "(Optional) If true the module with create a custom kms key. If false, it will use the aws managed kms key for sns."
  type        = bool
  default     = true
}

variable "alarm_sns_kms_key_id" {
  description = "(Optional) The ID of an AWS-managed customer master key (CMK) for Amazon SNS or a custom CMK"
  type        = string
  default     = null
}

variable "alarm_sns_topic_policy" {
  description = "(Optional) The fully-formed AWS policy as JSON. Will default to this if provided."
  type        = string
  default     = ""
}

variable "alarm_sns_org_access" {
  description = "(Optional) Set this to true if you want to allow any account in the org to interact with this topic."
  type        = bool
  default     = false
}

variable "alarm_sns_self_access" {
  description = "(Optional) Set this to false if you want to deny this account from having direct access to this topic."
  type        = bool
  default     = false
}

variable "alarm_sns_topic_subscribers" {
  description = "(Optional) Configuration for subscibres to the cloudwatch alarm SNS topic."
  type = map(object({
    protocol = string
    # The protocol to use. The possible values for this are: sqs, sms, lambda, application. (http or https are partially supported, see below) (email is an option but is unsupported, see below).
    endpoint = string
    # The endpoint to send data to, the contents will vary with the protocol.
    endpoint_auto_confirms = bool
    # Boolean indicating whether the end point is capable of auto confirming subscription e.g., PagerDuty (default is false)
    raw_message_delivery = bool
    # Boolean indicating whether or not to enable raw message delivery (the original message is directly passed, not wrapped in JSON with the original message in the message property) (default is false)
  }))
  default = {}
}