# -------------------------------------------------------------
# Allow DDevOps central auth AWS account to assume roles in this AWS account
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
# Local variables
# The intention here is to transform user inputs to other variable types that is usable directly with resources
# -------------------------------------------------------------

locals {
  # Transform child account map into separate lists, this split will make keys and values able to be interpolated inside resource definitions
  client-child-account-names = "${ keys(var.client-child-accounts) }"
  client-child-account-ids   = "${ values(var.client-child-accounts) }"
}

# -------------------------------------------------------------
# Allow this AWS account to assume roles in all other child AWS accounts
# -------------------------------------------------------------

# Switch to child accounts' [AdministratorAccess] role

data "aws_iam_policy_document" "iam_resource_policy_for_switching_roles_to_administrator_access" {
  count = "${length(local.client-child-account-ids)}"

  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    resources = [
      "arn:aws:iam::${element(local.client-child-account-ids, count.index)}:role/${var.role-name-for-cross-account-administrator-access}",
    ]
  }
}

resource "aws_iam_policy" "iam_policy_for_cross_account_administrator_access" {
  count       = "${length(local.client-child-account-ids)}"
  name        = "iam_policy_for_${element(local.client-child-account-names, count.index)}_cross_account_administrator_access"
  description = "iam_policy_for_${element(local.client-child-account-names, count.index)}_cross_account_administrator_access"
  path        = "/"
  policy      = "${data.aws_iam_policy_document.iam_resource_policy_for_switching_roles_to_administrator_access.*.json[count.index]}"
}

resource "aws_iam_group" "iam_group_for_cross_account_administrator_access" {
  count = "${length(local.client-child-account-ids)}"
  name  = "iam_group_for_${element(local.client-child-account-names, count.index)}_cross_account_administrator_access"
  path  = "/"
}

resource "aws_iam_group_policy_attachment" "cross_account_administrator_access_policy_attachment1" {
  count      = "${length(local.client-child-account-ids)}"
  group      = "${aws_iam_group.iam_group_for_cross_account_administrator_access.*.name[count.index]}"
  policy_arn = "${aws_iam_policy.iam_policy_for_cross_account_administrator_access.*.arn[count.index]}"
  depends_on = ["aws_iam_policy.iam_policy_for_cross_account_administrator_access"]
}

# Switch to child accounts' [Billing] role

data "aws_iam_policy_document" "iam_resource_policy_for_switching_roles_to_billing" {
  count = "${length(local.client-child-account-ids)}"

  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    resources = [
      "arn:aws:iam::${element(local.client-child-account-ids, count.index)}:role/${var.role-name-for-cross-account-billing}",
    ]
  }
}

resource "aws_iam_policy" "iam_policy_for_cross_account_billing" {
  count       = "${length(local.client-child-account-ids)}"
  name        = "iam_policy_for_${element(local.client-child-account-names, count.index)}_cross_account_billing"
  description = "iam_policy_for_${element(local.client-child-account-names, count.index)}_cross_account_billing"
  path        = "/"
  policy      = "${data.aws_iam_policy_document.iam_resource_policy_for_switching_roles_to_billing.*.json[count.index]}"
}

resource "aws_iam_group" "iam_group_for_cross_account_billing" {
  count = "${length(local.client-child-account-ids)}"
  name  = "iam_group_for_${element(local.client-child-account-names, count.index)}_cross_account_billing"
  path  = "/"
}

resource "aws_iam_group_policy_attachment" "cross_account_billing_policy_attachment1" {
  count      = "${length(local.client-child-account-ids)}"
  group      = "${aws_iam_group.iam_group_for_cross_account_billing.*.name[count.index]}"
  policy_arn = "${aws_iam_policy.iam_policy_for_cross_account_billing.*.arn[count.index]}"
  depends_on = ["aws_iam_policy.iam_policy_for_cross_account_billing"]
}

# Switch to child accounts' [DatabaseAdministrator] role

data "aws_iam_policy_document" "iam_resource_policy_for_switching_roles_to_database_administrator" {
  count = "${length(local.client-child-account-ids)}"

  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    resources = [
      "arn:aws:iam::${element(local.client-child-account-ids, count.index)}:role/${var.role-name-for-cross-account-database-administrator}",
    ]
  }
}

resource "aws_iam_policy" "iam_policy_for_cross_account_database_administrator" {
  count       = "${length(local.client-child-account-ids)}"
  name        = "iam_policy_for_${element(local.client-child-account-names, count.index)}_cross_account_database_administrator"
  description = "iam_policy_for_${element(local.client-child-account-names, count.index)}_cross_account_database_administrator"
  path        = "/"
  policy      = "${data.aws_iam_policy_document.iam_resource_policy_for_switching_roles_to_database_administrator.*.json[count.index]}"
}

resource "aws_iam_group" "iam_group_for_cross_account_database_administrator" {
  count = "${length(local.client-child-account-ids)}"
  name  = "iam_group_for_${element(local.client-child-account-names, count.index)}_cross_account_database_administrator"
  path  = "/"
}

resource "aws_iam_group_policy_attachment" "cross_account_database_administrator_policy_attachment1" {
  count      = "${length(local.client-child-account-ids)}"
  group      = "${aws_iam_group.iam_group_for_cross_account_database_administrator.*.name[count.index]}"
  policy_arn = "${aws_iam_policy.iam_policy_for_cross_account_database_administrator.*.arn[count.index]}"
  depends_on = ["aws_iam_policy.iam_policy_for_cross_account_database_administrator"]
}

# Switch to child accounts' [DataScientist] role

data "aws_iam_policy_document" "iam_resource_policy_for_switching_roles_to_data_scientist" {
  count = "${length(local.client-child-account-ids)}"

  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    resources = [
      "arn:aws:iam::${element(local.client-child-account-ids, count.index)}:role/${var.role-name-for-cross-account-data-scientist}",
    ]
  }
}

resource "aws_iam_policy" "iam_policy_for_cross_account_data_scientist" {
  count       = "${length(local.client-child-account-ids)}"
  name        = "iam_policy_for_${element(local.client-child-account-names, count.index)}_cross_account_data_scientist"
  description = "iam_policy_for_${element(local.client-child-account-names, count.index)}_cross_account_data_scientist"
  path        = "/"
  policy      = "${data.aws_iam_policy_document.iam_resource_policy_for_switching_roles_to_data_scientist.*.json[count.index]}"
}

resource "aws_iam_group" "iam_group_for_cross_account_data_scientist" {
  count = "${length(local.client-child-account-ids)}"
  name  = "iam_group_for_${element(local.client-child-account-names, count.index)}_cross_account_data_scientist"
  path  = "/"
}

resource "aws_iam_group_policy_attachment" "cross_account_data_scientist_policy_attachment1" {
  count      = "${length(local.client-child-account-ids)}"
  group      = "${aws_iam_group.iam_group_for_cross_account_data_scientist.*.name[count.index]}"
  policy_arn = "${aws_iam_policy.iam_policy_for_cross_account_data_scientist.*.arn[count.index]}"
  depends_on = ["aws_iam_policy.iam_policy_for_cross_account_data_scientist"]
}

# Switch to child accounts' [NetworkAdministrator] role

data "aws_iam_policy_document" "iam_resource_policy_for_switching_roles_to_network_administrator" {
  count = "${length(local.client-child-account-ids)}"

  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    resources = [
      "arn:aws:iam::${element(local.client-child-account-ids, count.index)}:role/${var.role-name-for-cross-account-network-administrator}",
    ]
  }
}

resource "aws_iam_policy" "iam_policy_for_cross_account_network_administrator" {
  count       = "${length(local.client-child-account-ids)}"
  name        = "iam_policy_for_${element(local.client-child-account-names, count.index)}_cross_account_network_administrator"
  description = "iam_policy_for_${element(local.client-child-account-names, count.index)}_cross_account_network_administrator"
  path        = "/"
  policy      = "${data.aws_iam_policy_document.iam_resource_policy_for_switching_roles_to_network_administrator.*.json[count.index]}"
}

resource "aws_iam_group" "iam_group_for_cross_account_network_administrator" {
  count = "${length(local.client-child-account-ids)}"
  name  = "iam_group_for_${element(local.client-child-account-names, count.index)}_cross_account_network_administrator"
  path  = "/"
}

resource "aws_iam_group_policy_attachment" "cross_account_network_administrator_policy_attachment1" {
  count      = "${length(local.client-child-account-ids)}"
  group      = "${aws_iam_group.iam_group_for_cross_account_network_administrator.*.name[count.index]}"
  policy_arn = "${aws_iam_policy.iam_policy_for_cross_account_network_administrator.*.arn[count.index]}"
  depends_on = ["aws_iam_policy.iam_policy_for_cross_account_network_administrator"]
}

# Switch to child accounts' [PowerUserAccess] role

data "aws_iam_policy_document" "iam_resource_policy_for_switching_roles_to_power_user_access" {
  count = "${length(local.client-child-account-ids)}"

  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    resources = [
      "arn:aws:iam::${element(local.client-child-account-ids, count.index)}:role/${var.role-name-for-cross-account-power-user-access}",
    ]
  }
}

resource "aws_iam_policy" "iam_policy_for_cross_account_power_user_access" {
  count       = "${length(local.client-child-account-ids)}"
  name        = "iam_policy_for_${element(local.client-child-account-names, count.index)}_cross_account_power_user_access"
  description = "iam_policy_for_${element(local.client-child-account-names, count.index)}_cross_account_power_user_access"
  path        = "/"
  policy      = "${data.aws_iam_policy_document.iam_resource_policy_for_switching_roles_to_power_user_access.*.json[count.index]}"
}

resource "aws_iam_group" "iam_group_for_cross_account_power_user_access" {
  count = "${length(local.client-child-account-ids)}"
  name  = "iam_group_for_${element(local.client-child-account-names, count.index)}_cross_account_power_user_access"
  path  = "/"
}

resource "aws_iam_group_policy_attachment" "cross_account_power_user_access_policy_attachment1" {
  count      = "${length(local.client-child-account-ids)}"
  group      = "${aws_iam_group.iam_group_for_cross_account_power_user_access.*.name[count.index]}"
  policy_arn = "${aws_iam_policy.iam_policy_for_cross_account_power_user_access.*.arn[count.index]}"
  depends_on = ["aws_iam_policy.iam_policy_for_cross_account_power_user_access"]
}

# Switch to child accounts' [SecurityAudit] role

data "aws_iam_policy_document" "iam_resource_policy_for_switching_roles_to_security_audit" {
  count = "${length(local.client-child-account-ids)}"

  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    resources = [
      "arn:aws:iam::${element(local.client-child-account-ids, count.index)}:role/${var.role-name-for-cross-account-security-audit}",
    ]
  }
}

resource "aws_iam_policy" "iam_policy_for_cross_account_security_audit" {
  count       = "${length(local.client-child-account-ids)}"
  name        = "iam_policy_for_${element(local.client-child-account-names, count.index)}_cross_account_security_audit"
  description = "iam_policy_for_${element(local.client-child-account-names, count.index)}_cross_account_security_audit"
  path        = "/"
  policy      = "${data.aws_iam_policy_document.iam_resource_policy_for_switching_roles_to_security_audit.*.json[count.index]}"
}

resource "aws_iam_group" "iam_group_for_cross_account_security_audit" {
  count = "${length(local.client-child-account-ids)}"
  name  = "iam_group_for_${element(local.client-child-account-names, count.index)}_cross_account_security_audit"
  path  = "/"
}

resource "aws_iam_group_policy_attachment" "cross_account_security_audit_policy_attachment1" {
  count      = "${length(local.client-child-account-ids)}"
  group      = "${aws_iam_group.iam_group_for_cross_account_security_audit.*.name[count.index]}"
  policy_arn = "${aws_iam_policy.iam_policy_for_cross_account_security_audit.*.arn[count.index]}"
  depends_on = ["aws_iam_policy.iam_policy_for_cross_account_security_audit"]
}

# Switch to child accounts' [SupportUser] role

data "aws_iam_policy_document" "iam_resource_policy_for_switching_roles_to_support_user" {
  count = "${length(local.client-child-account-ids)}"

  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    resources = [
      "arn:aws:iam::${element(local.client-child-account-ids, count.index)}:role/${var.role-name-for-cross-account-support-user}",
    ]
  }
}

resource "aws_iam_policy" "iam_policy_for_cross_account_support_user" {
  count       = "${length(local.client-child-account-ids)}"
  name        = "iam_policy_for_${element(local.client-child-account-names, count.index)}_cross_account_support_user"
  description = "iam_policy_for_${element(local.client-child-account-names, count.index)}_cross_account_support_user"
  path        = "/"
  policy      = "${data.aws_iam_policy_document.iam_resource_policy_for_switching_roles_to_support_user.*.json[count.index]}"
}

resource "aws_iam_group" "iam_group_for_cross_account_support_user" {
  count = "${length(local.client-child-account-ids)}"
  name  = "iam_group_for_${element(local.client-child-account-names, count.index)}_cross_account_support_user"
  path  = "/"
}

resource "aws_iam_group_policy_attachment" "cross_account_support_user_policy_attachment1" {
  count      = "${length(local.client-child-account-ids)}"
  group      = "${aws_iam_group.iam_group_for_cross_account_support_user.*.name[count.index]}"
  policy_arn = "${aws_iam_policy.iam_policy_for_cross_account_support_user.*.arn[count.index]}"
  depends_on = ["aws_iam_policy.iam_policy_for_cross_account_support_user"]
}

# Switch to child accounts' [SystemAdministrator] role

data "aws_iam_policy_document" "iam_resource_policy_for_switching_roles_to_system_administrator" {
  count = "${length(local.client-child-account-ids)}"

  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    resources = [
      "arn:aws:iam::${element(local.client-child-account-ids, count.index)}:role/${var.role-name-for-cross-account-system-administrator}",
    ]
  }
}

resource "aws_iam_policy" "iam_policy_for_cross_account_system_administrator" {
  count       = "${length(local.client-child-account-ids)}"
  name        = "iam_policy_for_${element(local.client-child-account-names, count.index)}_cross_account_system_administrator"
  description = "iam_policy_for_${element(local.client-child-account-names, count.index)}_cross_account_system_administrator"
  path        = "/"
  policy      = "${data.aws_iam_policy_document.iam_resource_policy_for_switching_roles_to_system_administrator.*.json[count.index]}"
}

resource "aws_iam_group" "iam_group_for_cross_account_system_administrator" {
  count = "${length(local.client-child-account-ids)}"
  name  = "iam_group_for_${element(local.client-child-account-names, count.index)}_cross_account_system_administrator"
  path  = "/"
}

resource "aws_iam_group_policy_attachment" "cross_account_system_administrator_policy_attachment1" {
  count      = "${length(local.client-child-account-ids)}"
  group      = "${aws_iam_group.iam_group_for_cross_account_system_administrator.*.name[count.index]}"
  policy_arn = "${aws_iam_policy.iam_policy_for_cross_account_system_administrator.*.arn[count.index]}"
  depends_on = ["aws_iam_policy.iam_policy_for_cross_account_system_administrator"]
}

# Switch to child accounts' [ViewOnlyAccess] role

data "aws_iam_policy_document" "iam_resource_policy_for_switching_roles_to_view_only_access" {
  count = "${length(local.client-child-account-ids)}"

  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    resources = [
      "arn:aws:iam::${element(local.client-child-account-ids, count.index)}:role/${var.role-name-for-cross-account-view-only-access}",
    ]
  }
}

resource "aws_iam_policy" "iam_policy_for_cross_account_view_only_access" {
  count       = "${length(local.client-child-account-ids)}"
  name        = "iam_policy_for_${element(local.client-child-account-names, count.index)}_cross_account_view_only_access"
  description = "iam_policy_for_${element(local.client-child-account-names, count.index)}_cross_account_view_only_access"
  path        = "/"
  policy      = "${data.aws_iam_policy_document.iam_resource_policy_for_switching_roles_to_view_only_access.*.json[count.index]}"
}

resource "aws_iam_group" "iam_group_for_cross_account_view_only_access" {
  count = "${length(local.client-child-account-ids)}"
  name  = "iam_group_for_${element(local.client-child-account-names, count.index)}_cross_account_view_only_access"
  path  = "/"
}

resource "aws_iam_group_policy_attachment" "cross_account_view_only_access_policy_attachment1" {
  count      = "${length(local.client-child-account-ids)}"
  group      = "${aws_iam_group.iam_group_for_cross_account_view_only_access.*.name[count.index]}"
  policy_arn = "${aws_iam_policy.iam_policy_for_cross_account_view_only_access.*.arn[count.index]}"
  depends_on = ["aws_iam_policy.iam_policy_for_cross_account_view_only_access"]
}

# -------------------------------------------------------------
# IAM groups and policy attachments for this AWS account
# -------------------------------------------------------------

# [AdministratorAccess] for this account (not other child accounts)

resource "aws_iam_group" "iam_group_for_administrator_access" {
  name = "iam_group_for_administrator_access"
  path = "/"
}

resource "aws_iam_group_policy_attachment" "administrator_access_policy_attachment1" {
  group      = "${aws_iam_group.iam_group_for_administrator_access.name}"
  policy_arn = "${var.policy-arn-for-administrator-access}"
}

# [Billing] for this account (not other child accounts)

resource "aws_iam_group" "iam_group_for_billing" {
  name = "iam_group_for_billing"
  path = "/"
}

resource "aws_iam_group_policy_attachment" "billing_policy_attachment1" {
  group      = "${aws_iam_group.iam_group_for_billing.name}"
  policy_arn = "${var.policy-arn-for-billing}"
}

# [DatabaseAdministrator] for this account (not other child accounts)

resource "aws_iam_group" "iam_group_for_database_administrator" {
  name = "iam_group_for_database_administrator"
  path = "/"
}

resource "aws_iam_group_policy_attachment" "database_administrator_policy_attachment1" {
  group      = "${aws_iam_group.iam_group_for_database_administrator.name}"
  policy_arn = "${var.policy-arn-for-database-administrator}"
}

# [DataScientist] for this account (not other child accounts)

resource "aws_iam_group" "iam_group_for_data_scientist" {
  name = "iam_group_for_data_scientist"
  path = "/"
}

resource "aws_iam_group_policy_attachment" "data_scientist_policy_attachment1" {
  group      = "${aws_iam_group.iam_group_for_data_scientist.name}"
  policy_arn = "${var.policy-arn-for-data-scientist}"
}

# [NetworkAdministrator] for this account (not other child accounts)

resource "aws_iam_group" "iam_group_for_network_administrator" {
  name = "iam_group_for_network_administrator"
  path = "/"
}

resource "aws_iam_group_policy_attachment" "network_administrator_policy_attachment1" {
  group      = "${aws_iam_group.iam_group_for_network_administrator.name}"
  policy_arn = "${var.policy-arn-for-network-administrator}"
}

# [PowerUserAccess] for this account (not other child accounts)

resource "aws_iam_group" "iam_group_for_power_user_access" {
  name = "iam_group_for_power_user_access"
  path = "/"
}

resource "aws_iam_group_policy_attachment" "power_user_access_policy_attachment1" {
  group      = "${aws_iam_group.iam_group_for_power_user_access.name}"
  policy_arn = "${var.policy-arn-for-power-user-access}"
}

# [SecurityAudit] for this account (not other child accounts)

resource "aws_iam_group" "iam_group_for_security_audit" {
  name = "iam_group_for_security_audit"
  path = "/"
}

resource "aws_iam_group_policy_attachment" "security_audit_policy_attachment1" {
  group      = "${aws_iam_group.iam_group_for_security_audit.name}"
  policy_arn = "${var.policy-arn-for-security-audit}"
}

# [SupportUser] for this account (not other child accounts)

resource "aws_iam_group" "iam_group_for_support_user" {
  name = "iam_group_for_support_user"
  path = "/"
}

resource "aws_iam_group_policy_attachment" "support_user_policy_attachment1" {
  group      = "${aws_iam_group.iam_group_for_support_user.name}"
  policy_arn = "${var.policy-arn-for-support-user}"
}

# [SystemAdministrator] for this account (not other child accounts)

resource "aws_iam_group" "iam_group_for_system_administrator" {
  name = "iam_group_for_system_administrator"
  path = "/"
}

resource "aws_iam_group_policy_attachment" "system_administrator_policy_attachment1" {
  group      = "${aws_iam_group.iam_group_for_system_administrator.name}"
  policy_arn = "${var.policy-arn-for-system-administrator}"
}

# [ViewOnlyAccess] for this account (not other child accounts)

resource "aws_iam_group" "iam_group_for_view_only_access" {
  name = "iam_group_for_view_only_access"
  path = "/"
}

resource "aws_iam_group_policy_attachment" "view_only_access_policy_attachment1" {
  group      = "${aws_iam_group.iam_group_for_view_only_access.name}"
  policy_arn = "${var.policy-arn-for-view-only-access}"
}
