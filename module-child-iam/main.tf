# -------------------------------------------------------------
# Allow DDevOps central auth AWS account to assume roles in this child AWS account
# -------------------------------------------------------------

data "aws_iam_policy_document" "iam_trust_policy_for_ddevops_cross_account_access" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    # Account IDs listed below will be allowed to assume roles in this account
    principals {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::${var.ddevops-auth-account-id}:root",
      ]
    }
  }
}

# AdministratorAccess

resource "aws_iam_role" "iam_role_for_ddevops_cross_account_administrator_access" {
  name               = "${var.role-name-for-ddevops-cross-account-administrator-access}"
  description        = "${var.role-name-for-ddevops-cross-account-administrator-access}"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.iam_trust_policy_for_ddevops_cross_account_access.json}"
}

resource "aws_iam_role_policy_attachment" "ddevops_cross_account_administrator_access_role_policy_attachment1" {
  role       = "${aws_iam_role.iam_role_for_ddevops_cross_account_administrator_access.name}"
  policy_arn = "${var.policy-arn-for-administrator-access}"
}

# Billing

resource "aws_iam_role" "iam_role_for_ddevops_cross_account_billing" {
  name               = "${var.role-name-for-ddevops-cross-account-billing}"
  description        = "${var.role-name-for-ddevops-cross-account-billing}"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.iam_trust_policy_for_ddevops_cross_account_access.json}"
}

resource "aws_iam_role_policy_attachment" "ddevops_cross_account_billing_role_policy_attachment1" {
  role       = "${aws_iam_role.iam_role_for_ddevops_cross_account_billing.name}"
  policy_arn = "${var.policy-arn-for-billing}"
}

# DatabaseAdministrator

resource "aws_iam_role" "iam_role_for_ddevops_cross_account_database_administrator" {
  name               = "${var.role-name-for-ddevops-cross-account-database-administrator}"
  description        = "${var.role-name-for-ddevops-cross-account-database-administrator}"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.iam_trust_policy_for_ddevops_cross_account_access.json}"
}

resource "aws_iam_role_policy_attachment" "ddevops_cross_account_database_administrator_role_policy_attachment1" {
  role       = "${aws_iam_role.iam_role_for_ddevops_cross_account_database_administrator.name}"
  policy_arn = "${var.policy-arn-for-database-administrator}"
}

# DataScientist

resource "aws_iam_role" "iam_role_for_ddevops_cross_account_data_scientist" {
  name               = "${var.role-name-for-ddevops-cross-account-data-scientist}"
  description        = "${var.role-name-for-ddevops-cross-account-data-scientist}"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.iam_trust_policy_for_ddevops_cross_account_access.json}"
}

resource "aws_iam_role_policy_attachment" "ddevops_cross_account_data_scientist_role_policy_attachment1" {
  role       = "${aws_iam_role.iam_role_for_ddevops_cross_account_data_scientist.name}"
  policy_arn = "${var.policy-arn-for-data-scientist}"
}

# NetworkAdministrator

resource "aws_iam_role" "iam_role_for_ddevops_cross_account_network_administrator" {
  name               = "${var.role-name-for-ddevops-cross-account-network-administrator}"
  description        = "${var.role-name-for-ddevops-cross-account-network-administrator}"
  assume_role_policy = "${data.aws_iam_policy_document.iam_trust_policy_for_ddevops_cross_account_access.json}"
}

resource "aws_iam_role_policy_attachment" "ddevops_cross_account_network_administrator_role_policy_attachment1" {
  role       = "${aws_iam_role.iam_role_for_ddevops_cross_account_network_administrator.name}"
  policy_arn = "${var.policy-arn-for-network-administrator}"
}

# PowerUserAccess

resource "aws_iam_role" "iam_role_for_ddevops_cross_account_power_user_access" {
  name               = "${var.role-name-for-ddevops-cross-account-power-user-access}"
  description        = "${var.role-name-for-ddevops-cross-account-power-user-access}"
  assume_role_policy = "${data.aws_iam_policy_document.iam_trust_policy_for_ddevops_cross_account_access.json}"
}

resource "aws_iam_role_policy_attachment" "ddevops_cross_account_power_user_access_role_policy_attachment1" {
  role       = "${aws_iam_role.iam_role_for_ddevops_cross_account_power_user_access.name}"
  policy_arn = "${var.policy-arn-for-power-user-access}"
}

# SecurityAudit

resource "aws_iam_role" "iam_role_for_ddevops_cross_account_security_audit" {
  name               = "${var.role-name-for-ddevops-cross-account-security-audit}"
  description        = "${var.role-name-for-ddevops-cross-account-security-audit}"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.iam_trust_policy_for_ddevops_cross_account_access.json}"
}

resource "aws_iam_role_policy_attachment" "ddevops_cross_account_security_audit_role_policy_attachment1" {
  role       = "${aws_iam_role.iam_role_for_ddevops_cross_account_security_audit.name}"
  policy_arn = "${var.policy-arn-for-security-audit}"
}

# SupportUser

resource "aws_iam_role" "iam_role_for_ddevops_cross_account_support_user" {
  name               = "${var.role-name-for-ddevops-cross-account-support-user}"
  description        = "${var.role-name-for-ddevops-cross-account-support-user}"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.iam_trust_policy_for_ddevops_cross_account_access.json}"
}

resource "aws_iam_role_policy_attachment" "ddevops_cross_account_support_user_role_policy_attachment1" {
  role       = "${aws_iam_role.iam_role_for_ddevops_cross_account_support_user.name}"
  policy_arn = "${var.policy-arn-for-support-user}"
}

# SystemAdministrator

resource "aws_iam_role" "iam_role_for_ddevops_cross_account_system_administrator" {
  name               = "${var.role-name-for-ddevops-cross-account-system-administrator}"
  description        = "${var.role-name-for-ddevops-cross-account-system-administrator}"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.iam_trust_policy_for_ddevops_cross_account_access.json}"
}

resource "aws_iam_role_policy_attachment" "ddevops_cross_account_system_administrator_role_policy_attachment1" {
  role       = "${aws_iam_role.iam_role_for_ddevops_cross_account_system_administrator.name}"
  policy_arn = "${var.policy-arn-for-system-administrator}"
}

# ViewOnlyAccess

resource "aws_iam_role" "iam_role_for_ddevops_cross_account_view_only_access" {
  name               = "${var.role-name-for-ddevops-cross-account-view-only-access}"
  description        = "${var.role-name-for-ddevops-cross-account-view-only-access}"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.iam_trust_policy_for_ddevops_cross_account_access.json}"
}

resource "aws_iam_role_policy_attachment" "ddevops_cross_account_view_only_role_policy_attachment1" {
  role       = "${aws_iam_role.iam_role_for_ddevops_cross_account_view_only_access.name}"
  policy_arn = "${var.policy-arn-for-view-only-access}"
}

# -------------------------------------------------------------
# Allow client / project central auth AWS account to assume roles in this child AWS account
# -------------------------------------------------------------

data "aws_iam_policy_document" "iam_trust_policy_for_cross_account_access" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    # Account IDs listed below will be allowed to assume roles in this account
    principals {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::${var.client-auth-account-id}:root",
      ]
    }
  }
}

# AdministratorAccess

resource "aws_iam_role" "iam_role_for_cross_account_administrator_access" {
  name               = "${var.role-name-for-cross-account-administrator-access}"
  description        = "${var.role-name-for-cross-account-administrator-access}"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.iam_trust_policy_for_cross_account_access.json}"
}

resource "aws_iam_role_policy_attachment" "cross_account_administrator_access_role_policy_attachment1" {
  role       = "${aws_iam_role.iam_role_for_cross_account_administrator_access.name}"
  policy_arn = "${var.policy-arn-for-administrator-access}"
}

# Billing

resource "aws_iam_role" "iam_role_for_cross_account_billing" {
  name               = "${var.role-name-for-cross-account-billing}"
  description        = "${var.role-name-for-cross-account-billing}"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.iam_trust_policy_for_cross_account_access.json}"
}

resource "aws_iam_role_policy_attachment" "cross_account_billing_role_policy_attachment1" {
  role       = "${aws_iam_role.iam_role_for_cross_account_billing.name}"
  policy_arn = "${var.policy-arn-for-billing}"
}

# DatabaseAdministrator

resource "aws_iam_role" "iam_role_for_cross_account_database_administrator" {
  name               = "${var.role-name-for-cross-account-database-administrator}"
  description        = "${var.role-name-for-cross-account-database-administrator}"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.iam_trust_policy_for_cross_account_access.json}"
}

resource "aws_iam_role_policy_attachment" "cross_account_database_administrator_role_policy_attachment1" {
  role       = "${aws_iam_role.iam_role_for_cross_account_database_administrator.name}"
  policy_arn = "${var.policy-arn-for-database-administrator}"
}

# DataScientist

resource "aws_iam_role" "iam_role_for_cross_account_data_scientist" {
  name               = "${var.role-name-for-cross-account-data-scientist}"
  description        = "${var.role-name-for-cross-account-data-scientist}"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.iam_trust_policy_for_cross_account_access.json}"
}

resource "aws_iam_role_policy_attachment" "cross_account_data_scientist_role_policy_attachment1" {
  role       = "${aws_iam_role.iam_role_for_cross_account_data_scientist.name}"
  policy_arn = "${var.policy-arn-for-data-scientist}"
}

# NetworkAdministrator

resource "aws_iam_role" "iam_role_for_cross_account_network_administrator" {
  name               = "${var.role-name-for-cross-account-network-administrator}"
  description        = "${var.role-name-for-cross-account-network-administrator}"
  assume_role_policy = "${data.aws_iam_policy_document.iam_trust_policy_for_cross_account_access.json}"
}

resource "aws_iam_role_policy_attachment" "cross_account_network_administrator_role_policy_attachment1" {
  role       = "${aws_iam_role.iam_role_for_cross_account_network_administrator.name}"
  policy_arn = "${var.policy-arn-for-network-administrator}"
}

# PowerUserAccess

resource "aws_iam_role" "iam_role_for_cross_account_power_user_access" {
  name               = "${var.role-name-for-cross-account-power-user-access}"
  description        = "${var.role-name-for-cross-account-power-user-access}"
  assume_role_policy = "${data.aws_iam_policy_document.iam_trust_policy_for_cross_account_access.json}"
}

resource "aws_iam_role_policy_attachment" "cross_account_power_user_access_role_policy_attachment1" {
  role       = "${aws_iam_role.iam_role_for_cross_account_power_user_access.name}"
  policy_arn = "${var.policy-arn-for-power-user-access}"
}

# SecurityAudit

resource "aws_iam_role" "iam_role_for_cross_account_security_audit" {
  name               = "${var.role-name-for-cross-account-security-audit}"
  description        = "${var.role-name-for-cross-account-security-audit}"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.iam_trust_policy_for_cross_account_access.json}"
}

resource "aws_iam_role_policy_attachment" "cross_account_security_audit_role_policy_attachment1" {
  role       = "${aws_iam_role.iam_role_for_cross_account_security_audit.name}"
  policy_arn = "${var.policy-arn-for-security-audit}"
}

# SupportUser

resource "aws_iam_role" "iam_role_for_cross_account_support_user" {
  name               = "${var.role-name-for-cross-account-support-user}"
  description        = "${var.role-name-for-cross-account-support-user}"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.iam_trust_policy_for_cross_account_access.json}"
}

resource "aws_iam_role_policy_attachment" "cross_account_support_user_role_policy_attachment1" {
  role       = "${aws_iam_role.iam_role_for_cross_account_support_user.name}"
  policy_arn = "${var.policy-arn-for-support-user}"
}

# SystemAdministrator

resource "aws_iam_role" "iam_role_for_cross_account_system_administrator" {
  name               = "${var.role-name-for-cross-account-system-administrator}"
  description        = "${var.role-name-for-cross-account-system-administrator}"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.iam_trust_policy_for_cross_account_access.json}"
}

resource "aws_iam_role_policy_attachment" "cross_account_system_administrator_role_policy_attachment1" {
  role       = "${aws_iam_role.iam_role_for_cross_account_system_administrator.name}"
  policy_arn = "${var.policy-arn-for-system-administrator}"
}

# ViewOnlyAccess

resource "aws_iam_role" "iam_role_for_cross_account_view_only_access" {
  name               = "${var.role-name-for-cross-account-view-only-access}"
  description        = "${var.role-name-for-cross-account-view-only-access}"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.iam_trust_policy_for_cross_account_access.json}"
}

resource "aws_iam_role_policy_attachment" "cross_account_view_only_role_policy_attachment1" {
  role       = "${aws_iam_role.iam_role_for_cross_account_view_only_access.name}"
  policy_arn = "${var.policy-arn-for-view-only-access}"
}
