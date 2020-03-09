terraform {
  required_version = ">= 0.10.3" # introduction of Local Values configuration language feature
}

# -------------------------------------------------------------
# CloudWatch/CloudTrail IAM Roles/Policies
# -------------------------------------------------------------

# IAM for CloudTrail
data "aws_iam_policy_document" "iam_trust_policy_for_cloudtrail" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "iam_resource_policy_for_cloudtrail" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "arn:aws:logs:*:${var.child-account-id}:log-group:${aws_cloudwatch_log_group.cloudwatch_log_group.name}:log-stream:*",
    ]
  }
}

resource "aws_iam_role" "iam_role_for_cloudtrail" {
  name               = "${var.child-project}-aws-compliance-${var.child-account-env}-cloudtrail-delivery-role"
  description        = "${var.child-project}-aws-compliance-${var.child-account-env}-cloudtrail-delivery-role"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.iam_trust_policy_for_cloudtrail.json}"
}

resource "aws_iam_policy" "iam_policy_for_cloudtrail" {
  name        = "${var.child-project}-aws-compliance-${var.child-account-env}-cloudtrail-delivery-policy"
  description = "${var.child-project}-aws-compliance-${var.child-account-env}-cloudtrail-delivery-policy"
  path        = "/"
  policy      = "${data.aws_iam_policy_document.iam_resource_policy_for_cloudtrail.json}"
}

resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment_for_cloudtrail" {
  role       = "${aws_iam_role.iam_role_for_cloudtrail.name}"
  policy_arn = "${aws_iam_policy.iam_policy_for_cloudtrail.arn}"
}

# IAM for Config
data "aws_iam_policy_document" "iam_trust_policy_for_config" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "iam_resource_policy_for_config" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetBucketAcl",
    ]

    resources = [
      "${var.logging-bucket-arn}",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "${var.logging-bucket-arn}/AWSLogs/*",
    ]

    condition {
      test     = "StringLike"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

resource "aws_iam_role" "iam_role_for_config" {
  name               = "${var.child-project}-aws-compliance-${var.child-account-env}-config-role"
  description        = "${var.child-project}-aws-compliance-${var.child-account-env}-config-role"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.iam_trust_policy_for_config.json}"
}

resource "aws_iam_policy" "iam_policy_for_config" {
  name        = "${var.child-project}-aws-compliance-${var.child-account-env}-config-policy"
  description = "${var.child-project}-aws-compliance-${var.child-account-env}-config-policy"
  path        = "/"
  policy      = "${data.aws_iam_policy_document.iam_resource_policy_for_config.json}"
}

resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment_for_config" {
  role       = "${aws_iam_role.iam_role_for_config.name}"
  policy_arn = "${aws_iam_policy.iam_policy_for_config.arn}"
}

# IAM for VPC Flow Logs

data "aws_iam_policy_document" "iam_trust_policy_for_vpc_flow_log" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "iam_resource_policy_for_vpc_flow_log" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_role" "iam_role_for_vpc_flow_log" {
  name               = "${var.child-project}-aws-compliance-${var.child-account-env}-flowlog-role"
  description        = "${var.child-project}-aws-compliance-${var.child-account-env}-flowlog-role"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.iam_trust_policy_for_vpc_flow_log.json}"
}

resource "aws_iam_policy" "iam_policy_for_vpc_flow_log" {
  name        = "${var.child-project}-aws-compliance-${var.child-account-env}-flowlog-policy"
  description = "${var.child-project}-aws-compliance-${var.child-account-env}-flowlog-policy"
  path        = "/"
  policy      = "${data.aws_iam_policy_document.iam_resource_policy_for_vpc_flow_log.json}"
}

resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment_for_vpc_flow_log" {
  role       = "${aws_iam_role.iam_role_for_vpc_flow_log.name}"
  policy_arn = "${aws_iam_policy.iam_policy_for_vpc_flow_log.arn}"
}

# -------------------------------------------------------------
# VPC Flow Logs
# -------------------------------------------------------------

resource "aws_cloudwatch_log_group" "cloudwatch_log_group_vpc_flow_log" {
  count = "${var.vpc-count}"
  name  = "/aws/vpc/${var.child-project}-aws-compliance-${var.child-account-env}-${element(var.vpc-ids, count.index)}"
}

resource "aws_flow_log" "vpc_flow_log" {
  count          = "${var.vpc-count}"
  log_group_name = "${aws_cloudwatch_log_group.cloudwatch_log_group_vpc_flow_log.*.name[count.index]}"
  iam_role_arn   = "${aws_iam_role.iam_role_for_vpc_flow_log.arn}"
  vpc_id         = "${element(var.vpc-ids, count.index)}"
  traffic_type   = "ALL"
}

# -------------------------------------------------------------
# SNS
# -------------------------------------------------------------

resource "aws_sns_topic" "alarms" {
  name = "${var.child-project}-${var.child-account-env}-cloudtrail-topic"
}

# -------------------------------------------------------------
# CloudWatch
# -------------------------------------------------------------
resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
  name = "${var.child-project}-aws-compliance-${var.child-account-env}-cloudtrail-log-group"
}

resource "aws_cloudwatch_log_metric_filter" "unauthorized_api_calls" {
  name           = "UnauthorizedAPICalls"
  pattern        = "{ ($.errorCode = \"*UnauthorizedOperation\") || ($.errorCode = \"AccessDenied*\") }"
  log_group_name = "${aws_cloudwatch_log_group.cloudwatch_log_group.name}"

  metric_transformation {
    name      = "UnauthorizedAPICalls"
    namespace = "${var.child-project}-aws-compliance-${var.child-account-env}-cis-metric"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "unauthorized_api_calls" {
  alarm_name                = "UnauthorizedAPICalls"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "${aws_cloudwatch_log_metric_filter.unauthorized_api_calls.id}"
  namespace                 = "${var.child-project}-aws-compliance-${var.child-account-env}-cis-metric"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring unauthorized API calls will help reveal application errors and may reduce time to detect malicious activity."
  alarm_actions             = ["${aws_sns_topic.alarms.arn}"]
  insufficient_data_actions = []
}

resource "aws_cloudwatch_log_metric_filter" "no_mfa_console_signin" {
  name           = "NoMFAConsoleSignin"
  pattern        = "{ ($.eventName = \"ConsoleLogin\") && ($.additionalEventData.MFAUsed != \"Yes\") }"
  log_group_name = "${aws_cloudwatch_log_group.cloudwatch_log_group.name}"

  metric_transformation {
    name      = "NoMFAConsoleSignin"
    namespace = "${var.child-project}-aws-compliance-${var.child-account-env}-cis-metric"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "no_mfa_console_signin" {
  alarm_name                = "NoMFAConsoleSignin"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "${aws_cloudwatch_log_metric_filter.no_mfa_console_signin.id}"
  namespace                 = "${var.child-project}-aws-compliance-${var.child-account-env}-cis-metric"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring for single-factor console logins will increase visibility into accounts that are not protected by MFA."
  alarm_actions             = ["${aws_sns_topic.alarms.arn}"]
  insufficient_data_actions = []
}

resource "aws_cloudwatch_log_metric_filter" "root_usage" {
  name           = "RootUsage"
  pattern        = "{ $.userIdentity.type = \"Root\" && $.userIdentity.invokedBy NOT EXISTS && $.eventType != \"AwsServiceEvent\" }"
  log_group_name = "${aws_cloudwatch_log_group.cloudwatch_log_group.name}"

  metric_transformation {
    name      = "RootUsage"
    namespace = "${var.child-project}-aws-compliance-${var.child-account-env}-cis-metric"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "root_usage" {
  alarm_name                = "RootUsage"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "${aws_cloudwatch_log_metric_filter.root_usage.id}"
  namespace                 = "${var.child-project}-aws-compliance-${var.child-account-env}-cis-metric"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring for root account logins will provide visibility into the use of a fully privileged account and an opportunity to reduce the use of it."
  alarm_actions             = ["${aws_sns_topic.alarms.arn}"]
  insufficient_data_actions = []
}

resource "aws_cloudwatch_log_metric_filter" "iam_changes" {
  name           = "IAMChanges"
  pattern        = "{($.eventName=DeleteGroupPolicy)||($.eventName=DeleteRolePolicy)||($.eventName=DeleteUserPolicy)||($.eventName=PutGroupPolicy)||($.eventName=PutRolePolicy)||($.eventName=PutUserPolicy)||($.eventName=CreatePolicy)||($.eventName=DeletePolicy)||($.eventName=CreatePolicyVersion)||($.eventName=DeletePolicyVersion)||($.eventName=AttachRolePolicy)||($.eventName=DetachRolePolicy)||($.eventName=AttachUserPolicy)||($.eventName=DetachUserPolicy)||($.eventName=AttachGroupPolicy)||($.eventName=DetachGroupPolicy)}"
  log_group_name = "${aws_cloudwatch_log_group.cloudwatch_log_group.name}"

  metric_transformation {
    name      = "IAMChanges"
    namespace = "${var.child-project}-aws-compliance-${var.child-account-env}-cis-metric"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "iam_changes" {
  alarm_name                = "IAMChanges"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "${aws_cloudwatch_log_metric_filter.iam_changes.id}"
  namespace                 = "${var.child-project}-aws-compliance-${var.child-account-env}-cis-metric"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring changes to IAM policies will help ensure authentication and authorization controls remain intact."
  alarm_actions             = ["${aws_sns_topic.alarms.arn}"]
  insufficient_data_actions = []
}

resource "aws_cloudwatch_log_metric_filter" "cloudtrail_cfg_changes" {
  name           = "CloudTrailCfgChanges"
  pattern        = "{ ($.eventName = CreateTrail) || ($.eventName = UpdateTrail) || ($.eventName = DeleteTrail) || ($.eventName = StartLogging) || ($.eventName = StopLogging) }"
  log_group_name = "${aws_cloudwatch_log_group.cloudwatch_log_group.name}"

  metric_transformation {
    name      = "CloudTrailCfgChanges"
    namespace = "${var.child-project}-aws-compliance-${var.child-account-env}-cis-metric"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "cloudtrail_cfg_changes" {
  alarm_name                = "CloudTrailCfgChanges"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "${aws_cloudwatch_log_metric_filter.cloudtrail_cfg_changes.id}"
  namespace                 = "${var.child-project}-aws-compliance-${var.child-account-env}-cis-metric"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring changes to CloudTrail's configuration will help ensure sustained visibility to activities performed in the AWS account."
  alarm_actions             = ["${aws_sns_topic.alarms.arn}"]
  insufficient_data_actions = []
}

resource "aws_cloudwatch_log_metric_filter" "console_signin_failures" {
  name           = "ConsoleSigninFailures"
  pattern        = "{ ($.eventName = ConsoleLogin) && ($.errorMessage = \"Failed authentication\") }"
  log_group_name = "${aws_cloudwatch_log_group.cloudwatch_log_group.name}"

  metric_transformation {
    name      = "ConsoleSigninFailures"
    namespace = "${var.child-project}-aws-compliance-${var.child-account-env}-cis-metric"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "console_signin_failures" {
  alarm_name                = "ConsoleSigninFailures"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "${aws_cloudwatch_log_metric_filter.console_signin_failures.id}"
  namespace                 = "${var.child-project}-aws-compliance-${var.child-account-env}-cis-metric"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring failed console logins may decrease lead time to detect an attempt to brute force a credential, which may provide an indicator, such as source IP, that can be used in other event correlation."
  alarm_actions             = ["${aws_sns_topic.alarms.arn}"]
  insufficient_data_actions = []
}

resource "aws_cloudwatch_log_metric_filter" "disable_or_delete_cmk" {
  name           = "DisableOrDeleteCMK"
  pattern        = "{ ($.eventSource = kms.amazonaws.com) && (($.eventName = DisableKey) || ($.eventName = ScheduleKeyDeletion)) }"
  log_group_name = "${aws_cloudwatch_log_group.cloudwatch_log_group.name}"

  metric_transformation {
    name      = "DisableOrDeleteCMK"
    namespace = "${var.child-project}-aws-compliance-${var.child-account-env}-cis-metric"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "disable_or_delete_cmk" {
  alarm_name                = "DisableOrDeleteCMK"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "${aws_cloudwatch_log_metric_filter.disable_or_delete_cmk.id}"
  namespace                 = "${var.child-project}-aws-compliance-${var.child-account-env}-cis-metric"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring failed console logins may decrease lead time to detect an attempt to brute force a credential, which may provide an indicator, such as source IP, that can be used in other event correlation."
  alarm_actions             = ["${aws_sns_topic.alarms.arn}"]
  insufficient_data_actions = []
}

resource "aws_cloudwatch_log_metric_filter" "s3_bucket_policy_changes" {
  name           = "S3BucketPolicyChanges"
  pattern        = "{ ($.eventSource = s3.amazonaws.com) && (($.eventName = PutBucketAcl) || ($.eventName = PutBucketPolicy) || ($.eventName = PutBucketCors) || ($.eventName = PutBucketLifecycle) || ($.eventName = PutBucketReplication) || ($.eventName = DeleteBucketPolicy) || ($.eventName = DeleteBucketCors) || ($.eventName = DeleteBucketLifecycle) || ($.eventName = DeleteBucketReplication)) }"
  log_group_name = "${aws_cloudwatch_log_group.cloudwatch_log_group.name}"

  metric_transformation {
    name      = "S3BucketPolicyChanges"
    namespace = "${var.child-project}-aws-compliance-${var.child-account-env}-cis-metric"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "s3_bucket_policy_changes" {
  alarm_name                = "S3BucketPolicyChanges"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "${aws_cloudwatch_log_metric_filter.s3_bucket_policy_changes.id}"
  namespace                 = "${var.child-project}-aws-compliance-${var.child-account-env}-cis-metric"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring changes to S3 bucket policies may reduce time to detect and correct permissive policies on sensitive S3 buckets."
  alarm_actions             = ["${aws_sns_topic.alarms.arn}"]
  insufficient_data_actions = []
}

resource "aws_cloudwatch_log_metric_filter" "aws_config_changes" {
  name           = "AWSConfigChanges"
  pattern        = "{ ($.eventSource = config.amazonaws.com) && (($.eventName=StopConfigurationRecorder)||($.eventName=DeleteDeliveryChannel)||($.eventName=PutDeliveryChannel)||($.eventName=PutConfigurationRecorder)) }"
  log_group_name = "${aws_cloudwatch_log_group.cloudwatch_log_group.name}"

  metric_transformation {
    name      = "AWSConfigChanges"
    namespace = "${var.child-project}-aws-compliance-${var.child-account-env}-cis-metric"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "aws_config_changes" {
  alarm_name                = "AWSConfigChanges"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "${aws_cloudwatch_log_metric_filter.aws_config_changes.id}"
  namespace                 = "${var.child-project}-aws-compliance-${var.child-account-env}-cis-metric"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring changes to AWS Config configuration will help ensure sustained visibility of configuration items within the AWS account."
  alarm_actions             = ["${aws_sns_topic.alarms.arn}"]
  insufficient_data_actions = []
}

resource "aws_cloudwatch_log_metric_filter" "security_group_changes" {
  name           = "SecurityGroupChanges"
  pattern        = "{ ($.eventName = AuthorizeSecurityGroupIngress) || ($.eventName = AuthorizeSecurityGroupEgress) || ($.eventName = RevokeSecurityGroupIngress) || ($.eventName = RevokeSecurityGroupEgress) || ($.eventName = CreateSecurityGroup) || ($.eventName = DeleteSecurityGroup)}"
  log_group_name = "${aws_cloudwatch_log_group.cloudwatch_log_group.name}"

  metric_transformation {
    name      = "SecurityGroupChanges"
    namespace = "${var.child-project}-aws-compliance-${var.child-account-env}-cis-metric"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "security_group_changes" {
  alarm_name                = "SecurityGroupChanges"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "${aws_cloudwatch_log_metric_filter.security_group_changes.id}"
  namespace                 = "${var.child-project}-aws-compliance-${var.child-account-env}-cis-metric"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring changes to security group will help ensure that resources and services are not unintentionally exposed."
  alarm_actions             = ["${aws_sns_topic.alarms.arn}"]
  insufficient_data_actions = []
}

resource "aws_cloudwatch_log_metric_filter" "nacl_changes" {
  name           = "NACLChanges"
  pattern        = "{ ($.eventName = CreateNetworkAcl) || ($.eventName = CreateNetworkAclEntry) || ($.eventName = DeleteNetworkAcl) || ($.eventName = DeleteNetworkAclEntry) || ($.eventName = ReplaceNetworkAclEntry) || ($.eventName = ReplaceNetworkAclAssociation) }"
  log_group_name = "${aws_cloudwatch_log_group.cloudwatch_log_group.name}"

  metric_transformation {
    name      = "NACLChanges"
    namespace = "${var.child-project}-aws-compliance-${var.child-account-env}-cis-metric"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "nacl_changes" {
  alarm_name                = "NACLChanges"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "${aws_cloudwatch_log_metric_filter.nacl_changes.id}"
  namespace                 = "${var.child-project}-aws-compliance-${var.child-account-env}-cis-metric"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring changes to NACLs will help ensure that AWS resources and services are not unintentionally exposed."
  alarm_actions             = ["${aws_sns_topic.alarms.arn}"]
  insufficient_data_actions = []
}

resource "aws_cloudwatch_log_metric_filter" "network_gw_changes" {
  name           = "NetworkGWChanges"
  pattern        = "{ ($.eventName = CreateCustomerGateway) || ($.eventName = DeleteCustomerGateway) || ($.eventName = AttachInternetGateway) || ($.eventName = CreateInternetGateway) || ($.eventName = DeleteInternetGateway) || ($.eventName = DetachInternetGateway) }"
  log_group_name = "${aws_cloudwatch_log_group.cloudwatch_log_group.name}"

  metric_transformation {
    name      = "NetworkGWChanges"
    namespace = "${var.child-project}-aws-compliance-${var.child-account-env}-cis-metric"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "network_gw_changes" {
  alarm_name                = "NetworkGWChanges"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "${aws_cloudwatch_log_metric_filter.network_gw_changes.id}"
  namespace                 = "${var.child-project}-aws-compliance-${var.child-account-env}-cis-metric"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring changes to network gateways will help ensure that all ingress/egress traffic traverses the VPC border via a controlled path."
  alarm_actions             = ["${aws_sns_topic.alarms.arn}"]
  insufficient_data_actions = []
}

resource "aws_cloudwatch_log_metric_filter" "route_table_changes" {
  name           = "RouteTableChanges"
  pattern        = "{ ($.eventName = CreateRoute) || ($.eventName = CreateRouteTable) || ($.eventName = ReplaceRoute) || ($.eventName = ReplaceRouteTableAssociation) || ($.eventName = DeleteRouteTable) || ($.eventName = DeleteRoute) || ($.eventName = DisassociateRouteTable) }"
  log_group_name = "${aws_cloudwatch_log_group.cloudwatch_log_group.name}"

  metric_transformation {
    name      = "RouteTableChanges"
    namespace = "${var.child-project}-aws-compliance-${var.child-account-env}-cis-metric"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "route_table_changes" {
  alarm_name                = "RouteTableChanges"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "${aws_cloudwatch_log_metric_filter.route_table_changes.id}"
  namespace                 = "${var.child-project}-aws-compliance-${var.child-account-env}-cis-metric"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring changes to route tables will help ensure that all VPC traffic flows through an expected path."
  alarm_actions             = ["${aws_sns_topic.alarms.arn}"]
  insufficient_data_actions = []
}

resource "aws_cloudwatch_log_metric_filter" "vpc_changes" {
  name           = "VPCChanges"
  pattern        = "{ ($.eventName = CreateVpc) || ($.eventName = DeleteVpc) || ($.eventName = ModifyVpcAttribute) || ($.eventName = AcceptVpcPeeringConnection) || ($.eventName = CreateVpcPeeringConnection) || ($.eventName = DeleteVpcPeeringConnection) || ($.eventName = RejectVpcPeeringConnection) || ($.eventName = AttachClassicLinkVpc) || ($.eventName = DetachClassicLinkVpc) || ($.eventName = DisableVpcClassicLink) || ($.eventName = EnableVpcClassicLink) }"
  log_group_name = "${aws_cloudwatch_log_group.cloudwatch_log_group.name}"

  metric_transformation {
    name      = "VPCChanges"
    namespace = "${var.child-project}-aws-compliance-${var.child-account-env}-cis-metric"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "vpc_changes" {
  alarm_name                = "VPCChanges"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "${aws_cloudwatch_log_metric_filter.vpc_changes.id}"
  namespace                 = "${var.child-project}-aws-compliance-${var.child-account-env}-cis-metric"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring changes to VPC will help ensure that all VPC traffic flows through an expected path."
  alarm_actions             = ["${aws_sns_topic.alarms.arn}"]
  insufficient_data_actions = []
}

# -------------------------------------------------------------
# Cloudtrail
# -------------------------------------------------------------
resource "aws_kms_alias" "cloudtrail" {
  name          = "alias/cloudtrail"
  target_key_id = "${aws_kms_key.cloudtrail.key_id}"
}

resource "aws_kms_key" "cloudtrail" {
  description             = "cloudtrail"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "key-default-1",
  "Statement": [
    {
      "Sid": "Enable IAM User Permissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": [ "arn:aws:iam::${var.child-account-id}:root",
                 "arn:aws:iam::${var.logging-account-id}:root" ]
      },
      "Action": "kms:*",
      "Resource": "*"
    },
    {
      "Sid": "Allow CloudTrail to encrypt loggings",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "kms:GenerateDataKey*",
      "Resource": "*",
      "Condition": {
        "StringLike": {
          "kms:EncryptionContext:aws:cloudtrail:arn": "arn:aws:cloudtrail:*:${var.child-account-id}:trail/*"
        }
      }
    }
  ]
}
POLICY
}

resource "aws_cloudtrail" "cloudtrail" {
  name                          = "${var.logging-bucket-name}-cloudtrail"
  s3_bucket_name                = "${var.logging-bucket-name}"
  s3_key_prefix                 = "${var.logging-bucket-name}-cloudtrail"
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true

  kms_key_id                 = "${aws_kms_key.cloudtrail.arn}"
  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloudwatch_log_group.arn}"
  cloud_watch_logs_role_arn  = "${aws_iam_role.iam_role_for_cloudtrail.arn}"
}

# -------------------------------------------------------------
# Config
# -------------------------------------------------------------
resource "aws_config_configuration_recorder" "config_configuration_recorder" {
  name     = "config_configuration_recorder"
  role_arn = "${aws_iam_role.iam_role_for_config.arn}"

  recording_group = {
    all_supported                 = "true"
    include_global_resource_types = "true"
  }
}

resource "aws_config_delivery_channel" "config_delivery_channel" {
  name           = "config_delivery_channel"
  s3_bucket_name = "${var.logging-bucket-name}"
  s3_key_prefix  = "${var.logging-bucket-name}-config"
  depends_on     = ["aws_config_configuration_recorder.config_configuration_recorder"]
}

resource "aws_config_configuration_recorder_status" "config_configuration_recorder_status" {
  name       = "${aws_config_configuration_recorder.config_configuration_recorder.name}"
  is_enabled = true
  depends_on = ["aws_config_delivery_channel.config_delivery_channel"]
}
