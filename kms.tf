## https://github.com/quickmute/terraform-aws-mod-kms-key
module "sns_kms_key" {
  source  = "app.terraform.io/embshd/mod-kms-key/aws"
  version = ">= 1.0.0, < 2.0.0"

  count = var.create_alarm_sns_kms_key ? 1 : 0

  alias_name              = ["${local.sns_topic_name}-kms-key"]
  description             = "the kms key used for the cloud watch alarm sns target."
  policy                  = data.aws_iam_policy_document.kms_access_policy[0].json
  deletion_window_in_days = 7
  tags                    = { Name = "${local.sns_topic_name}-kms-key" }
}
