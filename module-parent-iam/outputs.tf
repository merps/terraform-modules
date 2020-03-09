output "aws_account_id" {
  description = "AWS account ID of the account you've applied this module to"
  value       = "${data.aws_caller_identity.current.account_id}"
}

output "iam_role_for_devops_cross_account_administrator_access" {
  description = "ARN of iam_role_for_devops_cross_account_administrator_access (for use by DevOps team only)"
  value       = "${aws_iam_role.iam_role_for_devops_cross_account_administrator_access.arn}"
}

output "iam_role_for_devops_cross_account_billing" {
  description = "ARN of iam_role_for_devops_cross_account_billing (for use by DevOps team only)"
  value       = "${aws_iam_role.iam_role_for_devops_cross_account_billing.arn}"
}

output "iam_role_for_devops_cross_account_database_administrator" {
  description = "ARN of iam_role_for_devops_cross_account_database_administrator (for use by DevOps team only)"
  value       = "${aws_iam_role.iam_role_for_devops_cross_account_database_administrator.arn}"
}

output "iam_role_for_devops_cross_account_data_scientist" {
  description = "ARN of iam_role_for_devops_cross_account_data_scientist (for use by DevOps team only)"
  value       = "${aws_iam_role.iam_role_for_devops_cross_account_data_scientist.arn}"
}

output "iam_role_for_devops_cross_account_network_administrator" {
  description = "ARN of iam_role_for_devops_cross_account_network_administrator (for use by DevOps team only)"
  value       = "${aws_iam_role.iam_role_for_devops_cross_account_network_administrator.arn}"
}

output "iam_role_for_devops_cross_account_power_user_access" {
  description = "ARN of iam_role_for_devops_cross_account_power_user_access (for use by DevOps team only)"
  value       = "${aws_iam_role.iam_role_for_devops_cross_account_power_user_access.arn}"
}

output "iam_role_for_devops_cross_account_security_audit" {
  description = "ARN of iam_role_for_devops_cross_account_security_audit (for use by DevOps team only)"
  value       = "${aws_iam_role.iam_role_for_devops_cross_account_security_audit.arn}"
}

output "iam_role_for_devops_cross_account_support_user" {
  description = "ARN of iam_role_for_devops_cross_account_support_user (for use by DevOps team only)"
  value       = "${aws_iam_role.iam_role_for_devops_cross_account_support_user.arn}"
}

output "iam_role_for_devops_cross_account_system_administrator" {
  description = "ARN of iam_role_for_devops_cross_account_system_administrator (for use by DevOps team only)"
  value       = "${aws_iam_role.iam_role_for_devops_cross_account_system_administrator.arn}"
}

output "iam_role_for_devops_cross_account_view_only_access" {
  description = "ARN of iam_role_for_devops_cross_account_view_only_access (for use by DevOps team only)"
  value       = "${aws_iam_role.iam_role_for_devops_cross_account_view_only_access.arn}"
}

#

output "iam_group_for_cross_account_administrator_access" {
  description = "ARN of iam_group_for_cross_account_administrator_access (for use by client / project team only)"
  value       = "${aws_iam_group.iam_group_for_cross_account_administrator_access.*.arn}"
}

output "iam_group_for_cross_account_billing" {
  description = "ARN of iam_group_for_cross_account_billing (for use by client / project team only)"
  value       = "${aws_iam_group.iam_group_for_cross_account_billing.*.arn}"
}

output "iam_group_for_cross_account_database_administrator" {
  description = "ARN of iam_group_for_cross_account_database_administrator (for use by client / project team only)"
  value       = "${aws_iam_group.iam_group_for_cross_account_database_administrator.*.arn}"
}

output "iam_group_for_cross_account_data_scientist" {
  description = "ARN of iam_group_for_cross_account_data_scientist (for use by client / project team only)"
  value       = "${aws_iam_group.iam_group_for_cross_account_data_scientist.*.arn}"
}

output "iam_group_for_cross_account_network_administrator" {
  description = "ARN of iam_group_for_cross_account_network_administrator (for use by client / project team only)"
  value       = "${aws_iam_group.iam_group_for_cross_account_network_administrator.*.arn}"
}

output "iam_group_for_cross_account_power_user_access" {
  description = "ARN of iam_group_for_cross_account_power_user_access (for use by client / project team only)"
  value       = "${aws_iam_group.iam_group_for_cross_account_power_user_access.*.arn}"
}

output "iam_group_for_cross_account_security_audit" {
  description = "ARN of iam_group_for_cross_account_security_audit (for use by client / project team only)"
  value       = "${aws_iam_group.iam_group_for_cross_account_security_audit.*.arn}"
}

output "iam_group_for_cross_account_support_user" {
  description = "ARN of iam_group_for_cross_account_support_user (for use by client / project team only)"
  value       = "${aws_iam_group.iam_group_for_cross_account_support_user.*.arn}"
}

output "iam_group_for_cross_account_system_administrator" {
  description = "ARN of iam_group_for_cross_account_system_administrator (for use by client / project team only)"
  value       = "${aws_iam_group.iam_group_for_cross_account_system_administrator.*.arn}"
}

output "iam_group_for_cross_account_view_only_access" {
  description = "ARN of iam_group_for_cross_account_view_only_access (for use by client / project team only)"
  value       = "${aws_iam_group.iam_group_for_cross_account_view_only_access.*.arn}"
}

#

output "iam_group_for_administrator_access" {
  description = "ARN of iam_group_for_administrator_access (for use by client / project team only)"
  value       = "${aws_iam_group.iam_group_for_administrator_access.arn}"
}

output "iam_group_for_billing" {
  description = "ARN of iam_group_for_billing (for use by client / project team only)"
  value       = "${aws_iam_group.iam_group_for_billing.arn}"
}

output "iam_group_for_database_administrator" {
  description = "ARN of iam_group_for_database_administrator (for use by client / project team only)"
  value       = "${aws_iam_group.iam_group_for_database_administrator.arn}"
}

output "iam_group_for_data_scientist" {
  description = "ARN of iam_group_for_data_scientist (for use by client / project team only)"
  value       = "${aws_iam_group.iam_group_for_data_scientist.arn}"
}

output "iam_group_for_network_administrator" {
  description = "ARN of iam_group_for_network_administrator (for use by client / project team only)"
  value       = "${aws_iam_group.iam_group_for_network_administrator.arn}"
}

output "iam_group_for_power_user_access" {
  description = "ARN of iam_group_for_power_user_access (for use by client / project team only)"
  value       = "${aws_iam_group.iam_group_for_power_user_access.arn}"
}

output "iam_group_for_security_audit" {
  description = "ARN of iam_group_for_security_audit (for use by client / project team only)"
  value       = "${aws_iam_group.iam_group_for_security_audit.arn}"
}

output "iam_group_for_support_user" {
  description = "ARN of iam_group_for_support_user (for use by client / project team only)"
  value       = "${aws_iam_group.iam_group_for_support_user.arn}"
}

output "iam_group_for_system_administrator" {
  description = "ARN of iam_group_for_system_administrator (for use by client / project team only)"
  value       = "${aws_iam_group.iam_group_for_system_administrator.arn}"
}

output "iam_group_for_view_only_access" {
  description = "ARN of iam_group_for_view_only_access (for use by client / project team only)"
  value       = "${aws_iam_group.iam_group_for_view_only_access.arn}"
}
