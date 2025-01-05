# SQS Module

## Features
- Supports DLQ resource creation
  - SQS (itself) --> SQS (DLQ) --> Cloudwatch Alarm --> SNS
- FIFO supported

## ChangeLogs
### 1.0.0 
- Initial

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alarm_dlq_sns_topic"></a> [alarm\_dlq\_sns\_topic](#module\_alarm\_dlq\_sns\_topic) | app.terraform.io/embshd/mod-sns/aws | >= 1.0.0, < 2.0.0 |
| <a name="module_sns_kms_key"></a> [sns\_kms\_key](#module\_sns\_kms\_key) | app.terraform.io/embshd/mod-kms-key/aws | >= 1.0.0, < 2.0.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_metric_alarm.dlq](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_lambda_permission.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_sns_topic_subscription.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_sqs_queue.dlq](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue_policy.deadletter_queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_policy) | resource |
| [aws_sqs_queue_policy.source_queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_policy) | resource |
| [aws_sqs_queue_redrive_allow_policy.dlq](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_redrive_allow_policy) | resource |
| [aws_sqs_queue_redrive_allow_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_redrive_allow_policy) | resource |
| [aws_sqs_queue_redrive_policy.dlq](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_redrive_policy) | resource |
| [aws_sqs_queue_redrive_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_redrive_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.deadletter_queue_policy_default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.default_sns_resource_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.deny_not_our_organization](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.dlq_resource_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.kms_access_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.source_queue_policy_default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.sqs_resource_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_organizations_organization.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organization) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alarm_evaluation_period"></a> [alarm\_evaluation\_period](#input\_alarm\_evaluation\_period) | (Optional) The number of periods over which data is compared to the specified threshold. | `number` | `1` | no |
| <a name="input_alarm_period"></a> [alarm\_period](#input\_alarm\_period) | (Optional) The period in seconds over which the specified statistic is applied. | `number` | `60` | no |
| <a name="input_alarm_sns_include_failed_delivery_logging"></a> [alarm\_sns\_include\_failed\_delivery\_logging](#input\_alarm\_sns\_include\_failed\_delivery\_logging) | (Optional) Should failed message delivery be logged to CloudWatch? Defaults to false | `bool` | `false` | no |
| <a name="input_alarm_sns_kms_key_id"></a> [alarm\_sns\_kms\_key\_id](#input\_alarm\_sns\_kms\_key\_id) | (Optional) The ID of an AWS-managed customer master key (CMK) for Amazon SNS or a custom CMK | `string` | `null` | no |
| <a name="input_alarm_sns_org_access"></a> [alarm\_sns\_org\_access](#input\_alarm\_sns\_org\_access) | (Optional) Set this to true if you want to allow any account in the org to interact with this topic. | `bool` | `false` | no |
| <a name="input_alarm_sns_self_access"></a> [alarm\_sns\_self\_access](#input\_alarm\_sns\_self\_access) | (Optional) Set this to false if you want to deny this account from having direct access to this topic. | `bool` | `false` | no |
| <a name="input_alarm_sns_topic_display_name"></a> [alarm\_sns\_topic\_display\_name](#input\_alarm\_sns\_topic\_display\_name) | (Optional) The display name of the topic. This is what shows when you receive email from this topic. Cannot be longer than 100 characters or contain dots. | `string` | `null` | no |
| <a name="input_alarm_sns_topic_name"></a> [alarm\_sns\_topic\_name](#input\_alarm\_sns\_topic\_name) | (Optional) The name for the SNS topic. | `string` | `null` | no |
| <a name="input_alarm_sns_topic_policy"></a> [alarm\_sns\_topic\_policy](#input\_alarm\_sns\_topic\_policy) | (Optional) The fully-formed AWS policy as JSON. Will default to this if provided. | `string` | `""` | no |
| <a name="input_alarm_sns_topic_subscribers"></a> [alarm\_sns\_topic\_subscribers](#input\_alarm\_sns\_topic\_subscribers) | (Optional) Configuration for subscibres to the cloudwatch alarm SNS topic. | <pre>map(object({<br>    protocol = string<br>    # The protocol to use. The possible values for this are: sqs, sms, lambda, application. (http or https are partially supported, see below) (email is an option but is unsupported, see below).<br>    endpoint = string<br>    # The endpoint to send data to, the contents will vary with the protocol.<br>    endpoint_auto_confirms = bool<br>    # Boolean indicating whether the end point is capable of auto confirming subscription e.g., PagerDuty (default is false)<br>    raw_message_delivery = bool<br>    # Boolean indicating whether or not to enable raw message delivery (the original message is directly passed, not wrapped in JSON with the original message in the message property) (default is false)<br>  }))</pre> | `{}` | no |
| <a name="input_alarm_threshold"></a> [alarm\_threshold](#input\_alarm\_threshold) | (Optional) The value against which the specified statistic is compared. This parameter is required for alarms based on static thresholds, but should not be used for alarms based on anomaly detection models. | `number` | `0` | no |
| <a name="input_attach_default_policy"></a> [attach\_default\_policy](#input\_attach\_default\_policy) | (Optional) Defaults to 'true' for attaching a default policy, but you can override with 'false' if you don't want a default policy -- though you should still attach your own policy. | `bool` | `true` | no |
| <a name="input_content_based_deduplication"></a> [content\_based\_deduplication](#input\_content\_based\_deduplication) | (Optional) Enables content-based deduplication for FIFO queues | `bool` | `false` | no |
| <a name="input_create_alarm"></a> [create\_alarm](#input\_create\_alarm) | (Optional) whether to create a cloudwatch metric alarm when the deadletter queue contains greater than n messages. | `string` | `false` | no |
| <a name="input_create_alarm_sns_kms_key"></a> [create\_alarm\_sns\_kms\_key](#input\_create\_alarm\_sns\_kms\_key) | (Optional) If true the module with create a custom kms key. If false, it will use the aws managed kms key for sns. | `bool` | `true` | no |
| <a name="input_create_dlq"></a> [create\_dlq](#input\_create\_dlq) | (Optional) Determines whether to create SQS dead letter queue | `bool` | `false` | no |
| <a name="input_deduplication_scope"></a> [deduplication\_scope](#input\_deduplication\_scope) | (Optional) The length of time, in seconds, for which Amazon SQS can reuse a data key to encrypt or decrypt messages before calling AWS KMS again. An integer representing seconds, between 60 seconds (1 minute) and 86,400 seconds (24 hours) | `string` | `null` | no |
| <a name="input_delay_seconds"></a> [delay\_seconds](#input\_delay\_seconds) | (Optional) The time in seconds that the delivery of all messages in the queue will be delayed. An integer from 0 to 900 (15 minutes) | `number` | `0` | no |
| <a name="input_dlq_attach_default_policy"></a> [dlq\_attach\_default\_policy](#input\_dlq\_attach\_default\_policy) | (Optional) Defaults to 'true' for attaching a default policy, but you can override with 'false' if you don't want a default policy -- though you should still attach your own policy. | `bool` | `true` | no |
| <a name="input_dlq_content_based_deduplication"></a> [dlq\_content\_based\_deduplication](#input\_dlq\_content\_based\_deduplication) | (Optional) Enables content-based deduplication for FIFO queues | `bool` | `null` | no |
| <a name="input_dlq_deduplication_scope"></a> [dlq\_deduplication\_scope](#input\_dlq\_deduplication\_scope) | (Optional) Specifies whether message deduplication occurs at the message group or queue level | `string` | `null` | no |
| <a name="input_dlq_delay_seconds"></a> [dlq\_delay\_seconds](#input\_dlq\_delay\_seconds) | (Optional) The time in seconds that the delivery of all messages in the queue will be delayed. An integer from 0 to 900 (15 minutes) | `number` | `0` | no |
| <a name="input_dlq_kms_data_key_reuse_period_seconds"></a> [dlq\_kms\_data\_key\_reuse\_period\_seconds](#input\_dlq\_kms\_data\_key\_reuse\_period\_seconds) | (Optional) The length of time, in seconds, for which Amazon SQS can reuse a data key to encrypt or decrypt messages before calling AWS KMS again. An integer representing seconds, between 60 seconds (1 minute) and 86,400 seconds (24 hours) | `number` | `300` | no |
| <a name="input_dlq_kms_master_key_id"></a> [dlq\_kms\_master\_key\_id](#input\_dlq\_kms\_master\_key\_id) | (Optional) The ID of an AWS-managed customer master key (CMK) for Amazon SQS or a custom CMK | `string` | `null` | no |
| <a name="input_dlq_message_retention_seconds"></a> [dlq\_message\_retention\_seconds](#input\_dlq\_message\_retention\_seconds) | (Optional) The number of seconds Amazon SQS retains a message. Integer representing seconds, from 60 (1 minute) to 1209600 (14 days) | `number` | `null` | no |
| <a name="input_dlq_name"></a> [dlq\_name](#input\_dlq\_name) | (Optional) This is the human-readable name of the deadletter queue. If omitted, Terraform will assign a random name. if you are using an existing deadletter queue input that name here. | `string` | `null` | no |
| <a name="input_dlq_policy"></a> [dlq\_policy](#input\_dlq\_policy) | (Optional) The JSON policy for the dlq | `string` | `""` | no |
| <a name="input_dlq_receive_wait_time_seconds"></a> [dlq\_receive\_wait\_time\_seconds](#input\_dlq\_receive\_wait\_time\_seconds) | (Optional) The time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning. An integer from 0 to 20 (seconds) | `number` | `0` | no |
| <a name="input_dlq_redrive_allow_policy"></a> [dlq\_redrive\_allow\_policy](#input\_dlq\_redrive\_allow\_policy) | (Optional) The JSON policy to set up the Dead Letter Queue redrive permission, see AWS docs. | `any` | `{}` | no |
| <a name="input_dlq_source_policy_documents"></a> [dlq\_source\_policy\_documents](#input\_dlq\_source\_policy\_documents) | (Optional) List of IAM policy documents that are merged together into the exported document. Statements must have unique `sid`s | `list(string)` | `[]` | no |
| <a name="input_dlq_sqs_managed_sse_enabled"></a> [dlq\_sqs\_managed\_sse\_enabled](#input\_dlq\_sqs\_managed\_sse\_enabled) | (Optional) Boolean to enable server-side encryption (SSE) of message content with SQS-owned encryption keys | `bool` | `true` | no |
| <a name="input_dlq_visibility_timeout_seconds"></a> [dlq\_visibility\_timeout\_seconds](#input\_dlq\_visibility\_timeout\_seconds) | (Optional) The visibility timeout for the queue. An integer from 0 to 43200 (12 hours) | `number` | `null` | no |
| <a name="input_fifo_throughput_limit"></a> [fifo\_throughput\_limit](#input\_fifo\_throughput\_limit) | (Optional) Specifies whether the FIFO queue throughput quota applies to the entire queue or per message group | `string` | `null` | no |
| <a name="input_is_fifo_queue"></a> [is\_fifo\_queue](#input\_is\_fifo\_queue) | (Optional) Boolean designating a FIFO queue. If not set, it defaults to false making it standard. | `bool` | `false` | no |
| <a name="input_kms_data_key_reuse_period_seconds"></a> [kms\_data\_key\_reuse\_period\_seconds](#input\_kms\_data\_key\_reuse\_period\_seconds) | (Optional) The length of time, in seconds, for which Amazon SQS can reuse a data key to encrypt or decrypt messages before calling AWS KMS again. An integer representing seconds, between 60 seconds (1 minute) and 86,400 seconds (24 hours) | `number` | `null` | no |
| <a name="input_kms_master_key_id"></a> [kms\_master\_key\_id](#input\_kms\_master\_key\_id) | (Optional) The ID of an AWS-managed customer master key (CMK) for Amazon SQS or a custom CMK | `string` | `null` | no |
| <a name="input_max_message_size"></a> [max\_message\_size](#input\_max\_message\_size) | (Optional) The limit of how many bytes a message can contain before Amazon SQS rejects it. An integer from 1024 bytes (1 KiB) up to 262144 bytes (256 KiB) | `number` | `262144` | no |
| <a name="input_message_retention_seconds"></a> [message\_retention\_seconds](#input\_message\_retention\_seconds) | (Optional) The number of seconds Amazon SQS retains a message. Integer representing seconds, from 60 (1 minute) to 1209600 (14 days) | `number` | `345600` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) This is the human-readable name of the queue. If omitted, Terraform will assign a random name. | `string` | n/a | yes |
| <a name="input_policy"></a> [policy](#input\_policy) | (Optional) The JSON policy for the SQS queue that will be merged into a default resource policy. | `string` | `""` | no |
| <a name="input_queue_source_policy_documents"></a> [queue\_source\_policy\_documents](#input\_queue\_source\_policy\_documents) | (Optional) List of IAM policy documents that are merged together into the exported document. Statements must have unique `sid`s | `list(string)` | `[]` | no |
| <a name="input_receive_wait_time_seconds"></a> [receive\_wait\_time\_seconds](#input\_receive\_wait\_time\_seconds) | (Optional) The time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning. An integer from 0 to 20 (seconds) | `number` | `0` | no |
| <a name="input_redrive_allow_policy"></a> [redrive\_allow\_policy](#input\_redrive\_allow\_policy) | (Optional) The JSON policy to set up the Dead Letter Queue redrive permission, see AWS docs. | `any` | `{}` | no |
| <a name="input_redrive_policy"></a> [redrive\_policy](#input\_redrive\_policy) | (Optional) The JSON policy to set up the Dead Letter Queue, see AWS docs. Note: when specifying maxReceiveCount, you must specify it as an integer (5), and not a string ("5") | `any` | `{}` | no |
| <a name="input_sqs_name_override"></a> [sqs\_name\_override](#input\_sqs\_name\_override) | (Optional) If you set this to true then we won't add region to the name | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Required) A mapping of tags to assign to all resources | `map(string)` | n/a | yes |
| <a name="input_visibility_timeout_seconds"></a> [visibility\_timeout\_seconds](#input\_visibility\_timeout\_seconds) | (Optional) The visibility timeout for the queue. An integer from 0 to 43200 (12 hours) | `number` | `30` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alarm_sns_topic_arn"></a> [alarm\_sns\_topic\_arn](#output\_alarm\_sns\_topic\_arn) | the sns topic arn when a cloudwatch alarm is created |
| <a name="output_deadletter_queue_arn"></a> [deadletter\_queue\_arn](#output\_deadletter\_queue\_arn) | the arn of the deadletter queue |
| <a name="output_deadletter_queue_id"></a> [deadletter\_queue\_id](#output\_deadletter\_queue\_id) | The URL for the created Amazon SQS queue |
| <a name="output_kms_key_alias"></a> [kms\_key\_alias](#output\_kms\_key\_alias) | the alias of the custom kms key created by this module |
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | the arn of the custom kms key created by this module |
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | the id of the custom kms key created by this module |
| <a name="output_sqs_queue_arn"></a> [sqs\_queue\_arn](#output\_sqs\_queue\_arn) | The ARN of the SQS queue |
| <a name="output_sqs_queue_id"></a> [sqs\_queue\_id](#output\_sqs\_queue\_id) | The URL for the created Amazon SQS queue |
| <a name="output_sqs_queue_name"></a> [sqs\_queue\_name](#output\_sqs\_queue\_name) | The ARN of the SQS queue |
