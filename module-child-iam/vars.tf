# -------------------------------------------------------------
# AWS account ID
# -------------------------------------------------------------

data "aws_caller_identity" "current" {}

variable "devops-auth-account-id" {
  description = "Account ID of the DevOps central auth AWS account, defaults to account id of [master-central]."
  default     = "946231429173"
}

variable "client-auth-account-id" {
  description = "Account ID of the client / project's central auth AWS account."
}

# -------------------------------------------------------------
# Default IAM role names for DevOps assumed roles
# -------------------------------------------------------------

variable "role-name-for-devops-cross-account-administrator-access" {
  description = "Name of the IAM role that have the job function policy arn:aws:iam::aws:policy/AdministratorAccess"
  default     = "devops_cross_account_administrator_access"
}

variable "role-name-for-devops-cross-account-billing" {
  description = "Name of the IAM role that have the job function policy arn:aws:iam::aws:policy/job-function/Billing"
  default     = "devops_cross_account_billing"
}

variable "role-name-for-devops-cross-account-database-administrator" {
  description = "Name of the IAM role that have the job function policy arn:aws:iam::aws:policy/job-function/DatabaseAdministrator"
  default     = "devops_cross_account_database_administrator"
}

variable "role-name-for-devops-cross-account-data-scientist" {
  description = "Name of the IAM role that have the job function policy arn:aws:iam::aws:policy/job-function/DataScientist"
  default     = "devops_cross_account_data_scientist"
}

variable "role-name-for-devops-cross-account-network-administrator" {
  description = "Name of the IAM role that have the job function policy arn:aws:iam::aws:policy/job-function/NetworkAdministrator"
  default     = "devops_cross_account_network_administrator"
}

variable "role-name-for-devops-cross-account-power-user-access" {
  description = "Name of the IAM role that have the job function policy arn:aws:iam::aws:policy/PowerUserAccess"
  default     = "devops_cross_account_power_user_access"
}

variable "role-name-for-devops-cross-account-security-audit" {
  description = "Name of the IAM role that have the job function policy arn:aws:iam::aws:policy/SecurityAudit"
  default     = "devops_cross_account_security_audit"
}

variable "role-name-for-devops-cross-account-support-user" {
  description = "Name of the IAM role that have the job function policy arn:aws:iam::aws:policy/job-function/SupportUser"
  default     = "devops_cross_account_support_user"
}

variable "role-name-for-devops-cross-account-system-administrator" {
  description = "Name of the IAM role that have the job function policy arn:aws:iam::aws:policy/job-function/SystemAdministrator"
  default     = "devops_cross_account_system_administrator"
}

variable "role-name-for-devops-cross-account-view-only-access" {
  description = "Name of the IAM role that have the job function policy arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"
  default     = "devops_cross_account_view_only_access"
}

# -------------------------------------------------------------
# Default IAM role names for client's assumed roles
# -------------------------------------------------------------

variable "role-name-for-cross-account-administrator-access" {
  description = "Name of the IAM role that have the job function policy arn:aws:iam::aws:policy/AdministratorAccess"
  default     = "cross_account_administrator_access"
}

variable "role-name-for-cross-account-billing" {
  description = "Name of the IAM role that have the job function policy arn:aws:iam::aws:policy/job-function/Billing"
  default     = "cross_account_billing"
}

variable "role-name-for-cross-account-database-administrator" {
  description = "Name of the IAM role that have the job function policy arn:aws:iam::aws:policy/job-function/DatabaseAdministrator"
  default     = "cross_account_database_administrator"
}

variable "role-name-for-cross-account-data-scientist" {
  description = "Name of the IAM role that have the job function policy arn:aws:iam::aws:policy/job-function/DataScientist"
  default     = "cross_account_data_scientist"
}

variable "role-name-for-cross-account-network-administrator" {
  description = "Name of the IAM role that have the job function policy arn:aws:iam::aws:policy/job-function/NetworkAdministrator"
  default     = "cross_account_network_administrator"
}

variable "role-name-for-cross-account-power-user-access" {
  description = "Name of the IAM role that have the job function policy arn:aws:iam::aws:policy/PowerUserAccess"
  default     = "cross_account_power_user_access"
}

variable "role-name-for-cross-account-security-audit" {
  description = "Name of the IAM role that have the job function policy arn:aws:iam::aws:policy/SecurityAudit"
  default     = "cross_account_security_audit"
}

variable "role-name-for-cross-account-support-user" {
  description = "Name of the IAM role that have the job function policy arn:aws:iam::aws:policy/job-function/SupportUser"
  default     = "cross_account_support_user"
}

variable "role-name-for-cross-account-system-administrator" {
  description = "Name of the IAM role that have the job function policy arn:aws:iam::aws:policy/job-function/SystemAdministrator"
  default     = "cross_account_system_administrator"
}

variable "role-name-for-cross-account-view-only-access" {
  description = "Name of the IAM role that have the job function policy arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"
  default     = "cross_account_view_only_access"
}

# -------------------------------------------------------------
# AWS-managed job function policy ARNs
# -------------------------------------------------------------

variable "policy-arn-for-administrator-access" {
  default = "arn:aws:iam::aws:policy/AdministratorAccess"
}

variable "policy-arn-for-billing" {
  default = "arn:aws:iam::aws:policy/job-function/Billing"
}

variable "policy-arn-for-database-administrator" {
  default = "arn:aws:iam::aws:policy/job-function/DatabaseAdministrator"
}

variable "policy-arn-for-data-scientist" {
  default = "arn:aws:iam::aws:policy/job-function/DataScientist"
}

variable "policy-arn-for-network-administrator" {
  default = "arn:aws:iam::aws:policy/job-function/NetworkAdministrator"
}

variable "policy-arn-for-power-user-access" {
  default = "arn:aws:iam::aws:policy/PowerUserAccess"
}

variable "policy-arn-for-security-audit" {
  default = "arn:aws:iam::aws:policy/SecurityAudit"
}

variable "policy-arn-for-support-user" {
  default = "arn:aws:iam::aws:policy/job-function/SupportUser"
}

variable "policy-arn-for-system-administrator" {
  default = "arn:aws:iam::aws:policy/job-function/SystemAdministrator"
}

variable "policy-arn-for-view-only-access" {
  default = "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"
}
