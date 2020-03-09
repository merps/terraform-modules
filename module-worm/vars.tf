variable "child-account-id" {
  description = "The AWS account ID you are logging for / the client's AWS account ID"
}

variable "child-project" {
  description = "The client project/product you are logging for"
}

variable "child-account-env" {
  description = "The environment eg. dev, nonprod, prod"
}

variable "child-account-region" {
  description = "The AWS region of environment eg. dev, nonprod, prod"
}

data "aws_caller_identity" "current" {}