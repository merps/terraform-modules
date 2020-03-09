data "aws_caller_identity" "current" {}

variable "child-project" {
  description = "The client project/product you are logging for"
}

variable "child-account-env" {
  description = "The environment eg. dev, nonprod, prod"
}

variable "child-cloudwatch-log-group-count" {
  description = "The number of log groups you are passing into the [child-cloudwatch-log-group-names] list, this is a workaround"
}

variable "child-cloudwatch-log-group-names" {
  description = "The names of the CloudWatch Log Groups that you want to send over to the logging account."
  type = "list"
}

variable "child-cloudwatch-log-filter-pattern" {
  description = "CloudWatch Log filter pattern for the log events you're sending to the logging account."
  default = ""
}

variable "logging-account-cloudwatch-log-destination-arn" {
  description = "The CloudWatch Log Destination ARN in the logging account to send CloudWatch Log events to."
}
