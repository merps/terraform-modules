output "vpc-flow-log-cloudwatch-log-group-name" {
    value = "${aws_cloudwatch_log_group.cloudwatch_log_group_vpc_flow_log.*.name}"
}

output "vpc-flow-log-id" {
    value = "${aws_flow_log.vpc_flow_log.*.id}"
}