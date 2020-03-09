# -------------------------------------------------------------
# S3 bucket to store client's logs
# -------------------------------------------------------------
resource "aws_s3_bucket" "logging_bucket" {
  bucket        = "${var.child-project}-${var.child-account-env}"
  region        = "${var.child-account-region}"
  force_destroy = true

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::${var.child-project}-${var.child-account-env}"
        },
        {
            "Sid": "AWSConfigBucketPermissionsCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "config.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::${var.child-project}-${var.child-account-env}"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": [
              "arn:aws:s3:::${var.child-project}-${var.child-account-env}/${var.child-project}-${var.child-account-env}-cloudtrail/AWSLogs/${var.child-account-id}/*"
            ],
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        },
        {
            "Sid": "AWSConfigWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "config.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": [
              "arn:aws:s3:::${var.child-project}-${var.child-account-env}/${var.child-project}-${var.child-account-env}-config/AWSLogs/${var.child-account-id}/*"
            ],
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}

# -------------------------------------------------------------
# Logging account - Lambda function that processes logs sent to Kinesis Firehose, it extracts individual log events from records sent by Cloudwatch Logs subscription filters
# This is available as a Lambda function blueprint if you search for "kinesis-firehose-cloudwatch-logs-processor-python"
# Reference: https://docs.aws.amazon.com/firehose/latest/dev/data-transformation.html
# -------------------------------------------------------------

data "aws_iam_policy_document" "logging_iam_trust_policy_for_lambda" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "logging_iam_resource_policy_for_lambda" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_role" "logging_iam_role_for_lambda" {
  name               = "${var.child-project}-aws-compliance-${var.child-account-env}-lambda-firehose-role"
  description        = "${var.child-project}-aws-compliance-${var.child-account-env}-lambda-firehose-role"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.logging_iam_trust_policy_for_lambda.json}"
}

resource "aws_iam_policy" "logging_iam_policy_for_lambda" {
  name        = "${var.child-project}-aws-compliance-${var.child-account-env}-lambda-firehose-policy"
  description = "${var.child-project}-aws-compliance-${var.child-account-env}-lambda-firehose-policy"
  path        = "/"
  policy      = "${data.aws_iam_policy_document.logging_iam_resource_policy_for_lambda.json}"
}

resource "aws_iam_role_policy_attachment" "logging_iam_role_policy_attachment_for_lambda" {
  role       = "${aws_iam_role.logging_iam_role_for_lambda.name}"
  policy_arn = "${aws_iam_policy.logging_iam_policy_for_lambda.arn}"
}

data "archive_file" "lambda_function_archive_for_kinesis_firehose_cloudwatch_logs_processor" {
  type        = "zip"
  source_dir  = "${path.module}/kinesis-firehose-cloudwatch-logs-processor-python"
  output_path = "${path.module}/kinesis-firehose-cloudwatch-logs-processor-python.zip"
}

resource "aws_lambda_function" "lambda_function_for_kinesis_firehose_cloudwatch_logs_processor" {
  filename         = "${data.archive_file.lambda_function_archive_for_kinesis_firehose_cloudwatch_logs_processor.output_path}"
  source_code_hash = "${data.archive_file.lambda_function_archive_for_kinesis_firehose_cloudwatch_logs_processor.output_base64sha256}"
  function_name    = "${var.child-project}-aws-compliance-${var.child-account-env}-kinesis-firehose-processor"
  description      = "An Amazon Kinesis Firehose stream processor that extracts individual log events from records sent by Cloudwatch Logs subscription filters."
  role             = "${aws_iam_role.logging_iam_role_for_lambda.arn}"
  handler          = "lambda_function.handler"
  runtime          = "python2.7"
  timeout          = "60"
  memory_size      = "128"

  tags {
    "lambda-console:blueprint" = "kinesis-firehose-cloudwatch-logs-processor-python"
  }
}

# -------------------------------------------------------------
# Logging account - CloudWatch Logs IAM role
# -------------------------------------------------------------

data "aws_iam_policy_document" "logging_iam_trust_policy_for_cloudwatch_logs" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["logs.${var.child-account-region}.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "logging_iam_resource_policy_for_cloudwatch_logs" {
  statement {
    effect = "Allow"

    actions = [
      "firehose:*",
    ]

    resources = [
      "arn:aws:firehose:${var.child-account-region}:${data.aws_caller_identity.current.account_id}:*",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "iam:PassRole",
    ]

    resources = [
      "${aws_iam_role.logging_iam_role_for_cloudwatch_logs.arn}",
    ]
  }
}

resource "aws_iam_role" "logging_iam_role_for_cloudwatch_logs" {
  name               = "${var.child-project}-aws-compliance-${var.child-account-env}-cloudwatch-role"
  description        = "${var.child-project}-aws-compliance-${var.child-account-env}-cloudwatch-role"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.logging_iam_trust_policy_for_cloudwatch_logs.json}"
}

resource "aws_iam_policy" "logging_iam_policy_for_cloudwatch_logs" {
  name        = "${var.child-project}-aws-compliance-${var.child-account-env}-cloudwatch-policy"
  description = "${var.child-project}-aws-compliance-${var.child-account-env}-cloudwatch-policy"
  path        = "/"
  policy      = "${data.aws_iam_policy_document.logging_iam_resource_policy_for_cloudwatch_logs.json}"
}

resource "aws_iam_role_policy_attachment" "logging_iam_role_policy_attachment_for_cloudwatch_logs" {
  role       = "${aws_iam_role.logging_iam_role_for_cloudwatch_logs.name}"
  policy_arn = "${aws_iam_policy.logging_iam_policy_for_cloudwatch_logs.arn}"
}

# -------------------------------------------------------------
# Logging account - Kinesis Firehose IAM role
# -------------------------------------------------------------

data "aws_iam_policy_document" "logging_iam_trust_policy_for_kinesis_firehose" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "logging_iam_resource_policy_for_kinesis_firehose" {
  statement {
    effect = "Allow"

    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject",
    ]

    resources = [
      "${aws_s3_bucket.logging_bucket.arn}",
      "${aws_s3_bucket.logging_bucket.arn}/*",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "lambda:InvokeFunction",
      "lambda:GetFunctionConfiguration",
    ]

    resources = [
      "${aws_lambda_function.lambda_function_for_kinesis_firehose_cloudwatch_logs_processor.arn}:$LATEST",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "logs:PutLogEvents",
    ]

    resources = [
      "arn:aws:logs:${var.child-account-region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/kinesisfirehose/${aws_kinesis_firehose_delivery_stream.logging_kinesis_firehose_stream.name}:log-stream:*",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "kinesis:DescribeStream",
      "kinesis:GetShardIterator",
      "kinesis:GetRecords",
    ]

    resources = [
      "arn:aws:kinesis:${var.child-account-region}:${data.aws_caller_identity.current.account_id}:stream/${aws_kinesis_firehose_delivery_stream.logging_kinesis_firehose_stream.name}",
    ]
  }
}

resource "aws_iam_role" "logging_iam_role_for_kinesis_firehose" {
  name               = "${var.child-project}-aws-compliance-${var.child-account-env}-kinesis-role"
  description        = "${var.child-project}-aws-compliance-${var.child-account-env}-kinesis-role"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.logging_iam_trust_policy_for_kinesis_firehose.json}"
}

resource "aws_iam_policy" "logging_iam_policy_for_kinesis_firehose" {
  name        = "${var.child-project}-aws-compliance-${var.child-account-env}-kinesis-policy"
  description = "${var.child-project}-aws-compliance-${var.child-account-env}-kinesis-policy"
  path        = "/"
  policy      = "${data.aws_iam_policy_document.logging_iam_resource_policy_for_kinesis_firehose.json}"
}

resource "aws_iam_role_policy_attachment" "logging_iam_role_policy_attachment_for_kinesis_firehose" {
  role       = "${aws_iam_role.logging_iam_role_for_kinesis_firehose.name}"
  policy_arn = "${aws_iam_policy.logging_iam_policy_for_kinesis_firehose.arn}"
}

# -------------------------------------------------------------
# Logging account - Kinesis Firehose delivery stream and S3
# -------------------------------------------------------------

resource "aws_kinesis_firehose_delivery_stream" "logging_kinesis_firehose_stream" {
  name        = "${var.child-project}-aws-compliance-${var.child-account-env}-flow-log-stream"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = "${aws_iam_role.logging_iam_role_for_kinesis_firehose.arn}"
    bucket_arn = "${aws_s3_bucket.logging_bucket.arn}"
    prefix     = "${var.child-project}-${var.child-account-env}-cloudwatch-flow-logs/"

    processing_configuration = [
      {
        enabled = "true"

        processors = [
          {
            type = "Lambda"

            parameters = [
              {
                parameter_name  = "LambdaArn"
                parameter_value = "${aws_lambda_function.lambda_function_for_kinesis_firehose_cloudwatch_logs_processor.arn}:$LATEST"
              },
            ]
          },
        ]
      },
    ]
  }
}

# -------------------------------------------------------------
# Logging account - CloudWatch destination and associated policy
# -------------------------------------------------------------

data "aws_iam_policy_document" "logging_iam_destination_policy_for_cross_account_cloudwatch" {
  statement {
    effect = "Allow"

    principals = {
      type = "AWS"

      identifiers = [
        "${var.child-account-id}",
      ]
    }

    actions = [
      "logs:PutSubscriptionFilter",
    ]

    resources = [
      "${aws_cloudwatch_log_destination.logging_cloudwatch_log_destination_for_cross_account_cloudwatch.arn}",
    ]
  }
}

resource "aws_cloudwatch_log_destination" "logging_cloudwatch_log_destination_for_cross_account_cloudwatch" {
  name       = "${var.child-project}-aws-compliance-${var.child-account-env}-flow-log-destination"
  role_arn   = "${aws_iam_role.logging_iam_role_for_cloudwatch_logs.arn}"
  target_arn = "${aws_kinesis_firehose_delivery_stream.logging_kinesis_firehose_stream.arn}"
}

resource "aws_cloudwatch_log_destination_policy" "logging_cloudwatch_log_destination_policy" {
  destination_name = "${aws_cloudwatch_log_destination.logging_cloudwatch_log_destination_for_cross_account_cloudwatch.name}"
  access_policy    = "${data.aws_iam_policy_document.logging_iam_destination_policy_for_cross_account_cloudwatch.json}"
}
