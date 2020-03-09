output "cloudwatch_log_destination_arn" {
  description = "The CloudWatch Log Destination ARN for sending cross-account CloudWatch Log events to."
  value = "${aws_cloudwatch_log_destination.logging_cloudwatch_log_destination_for_cross_account_cloudwatch.arn}"
}

output "bucket_name" {
  value = "${aws_s3_bucket.logging_bucket.id}"
}

output "bucket_arn" {
  value = "${aws_s3_bucket.logging_bucket.arn}"
}

output "bucket_domain_name" {
  value = "${aws_s3_bucket.logging_bucket.bucket_domain_name}"
}
