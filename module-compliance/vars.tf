variable "vpc-ids" {
  description = "A list of VPC IDs that you want to record the flow logs for."
  type        = "list"
}

variable "vpc-count" {
  description = "The number of VPCs you are passing into the [vpc-ids] list, this is a workaround"
}

variable "child-account-id" {
  description = "The AWS account ID you are logging for / the client's AWS account ID"
}

variable "child-project" {
  description = "The client project/product you are logging for"
}

variable "child-account-env" {
  description = "The environment eg. dev, nonprod, prod"
}

variable "logging-bucket-name" {
  description = "Logging Bucket Name to configure Cloudtrail for."
}

variable "logging-bucket-arn" {
  description = "The ARN for Environments Logging Archive"
}

variable "logging-account-id" {
  description = "The ARN for Environments Logging Archive"
}
