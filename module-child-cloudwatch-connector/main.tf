terraform {
  required_version = ">= 0.10.3" # introduction of Local Values configuration language feature
}

# Send CloudWatch Log events of a child account to a logging account's CloudWatch Logs Destination
resource "aws_cloudwatch_log_subscription_filter" "child_cloudwatch_log_subscription_filter" {
  count           = "${var.child-cloudwatch-log-group-count}"
  name            = "${element(var.child-cloudwatch-log-group-names, count.index)}-subfilter"
  log_group_name  = "${element(var.child-cloudwatch-log-group-names, count.index)}"
  filter_pattern  = "${var.child-cloudwatch-log-filter-pattern}"
  destination_arn = "${var.logging-account-cloudwatch-log-destination-arn}"
  distribution    = "ByLogStream"
}