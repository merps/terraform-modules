## Features

The [parent-iam] module is for use with a parent AWS account that is designated for user authentication purposes only (otherwise known as central auth), the module sets up the following:

* For DevOps team:
    * IAM trust policy to allow DevOps team to assume roles in this account from DevOps central auth account (defaults to [master-central-auth])
    * IAM roles that utilise AWS-managed job function role policies for DevOps team

* For client / project team:
    * IAM policies and groups to allow client / project team to assume roles from this central auth account to all other client / project accounts
    * IAM groups that have AWS-managed job function role policies attached for this central auth account

The term 'parent' in this module refers to an AWS account that is used for centralised authentication purposes, for example this module would be suitable for use with any client / project's AWS account that is designated for authentication purposes only. This also means the 'parent' AWS account should be one that contains actual IAM user definitions, as opposed to 'child' accounts that have IAM roles only (without any IAM users).

The term 'child' in this module refers to any AWS account that is **NOT** used for centralised authentication purposes, in other words any AWS accounts that does **NOT** contain IAM users or IAM groups.

## How this module works

* This module creates the following for a given parent AWS account:
    * IAM trust policy that allows [master-central-auth] account to assume roles into the given parent AWS account
    * IAM roles that can be assumed via the [master-central-auth] account
    * IAM access policies that allow assuming roles to the AWS accounts given by the [client-child-accounts] input map
    * IAM groups that allow assuming roles to the AWS accounts given by the [client-child-accounts] input map
    * IAM groups and policy attachments that correspond to AWS-managed job function permissions for the parent account

* Red:
    * Denotes AWS account name substitution
    * The AWS account name you pass in from the [client-child-accounts] map will eventually end up in the names of each IAM group

* Light Blue:
    * Denotes AWS account ID substitution
    * The AWS account ID you pass in from the [client-child-accounts] map will eventually end up in the IAM policies of each IAM group, which specifies the AWS account and IAM Role name each IAM group is allowed to assume roles to

* Purple:
    * Denotes the resources created by Terraform
    * Due to the use of the 'count' parameter, for each job-function policy, an IAM Role, IAM Group and IAM Group Policy Attachment resource will be created for each AWS account in the [client-child-accounts] map

![module-parent-iam.png](https://github.com/merps/terraform-modules/blob/master/module-parent-iam/module-parent-iam.png)

## Usage

The following example is for deploying the module inside of a project's central auth environment main.tf file, it is assumed that you have the account IDs of all the child accounts that you want to grant access to (this can be added to the input map on an ongoing basis).

\central\main.tf:
```
    provider "aws" {
        profile = "project_central_auth"
        region  = "ap-southeast-2"
    }

    module "central_iam" {
        source              = "/module-parent-iam"

        client-child-accounts = {
            master-biller   = "${var.master-account-id}"
            logging         = "${var.logging-account-id}"
            shared          = "${var.shared-account-id}"
            prod            = "${var.prod-account-id}"
            nonprod         = "${var.nonprod-account-id}"
        }
        
        providers = {
            "aws" = "aws.project_central_auth"
        }
    }
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| client-child-accounts | List of the client / project's child AWS accounts. | map | - | yes |
| devops-auth-account-id | Account ID of the DevOps central auth AWS account, defaults to account id of [master-central-auth]. | string | `123456789` | no |
| policy-arn-for-administrator-access |  | string | `arn:aws:iam::aws:policy/AdministratorAccess` | no |
| policy-arn-for-billing |  | string | `arn:aws:iam::aws:policy/job-function/Billing` | no |
| policy-arn-for-data-scientist |  | string | `arn:aws:iam::aws:policy/job-function/DataScientist` | no |
| policy-arn-for-database-administrator |  | string | `arn:aws:iam::aws:policy/job-function/DatabaseAdministrator` | no |
| policy-arn-for-network-administrator |  | string | `arn:aws:iam::aws:policy/job-function/NetworkAdministrator` | no |
| policy-arn-for-power-user-access |  | string | `arn:aws:iam::aws:policy/PowerUserAccess` | no |
| policy-arn-for-security-audit |  | string | `arn:aws:iam::aws:policy/SecurityAudit` | no |
| policy-arn-for-support-user |  | string | `arn:aws:iam::aws:policy/job-function/SupportUser` | no |
| policy-arn-for-system-administrator |  | string | `arn:aws:iam::aws:policy/job-function/SystemAdministrator` | no |
| policy-arn-for-view-only-access |  | string | `arn:aws:iam::aws:policy/job-function/ViewOnlyAccess` | no |
| role-name-for-cross-account-administrator-access | Name of the IAM role in other child AWS accounts that have the job function policy arn:aws:iam::aws:policy/AdministratorAccess | string | `iam_role_for_cross_account_administrator_access` | no |
| role-name-for-cross-account-billing | Name of the IAM role in other child AWS accounts that have the job function policy arn:aws:iam::aws:policy/job-function/Billing | string | `iam_role_for_cross_account_billing` | no |
| role-name-for-cross-account-data-scientist | Name of the IAM role in other child AWS accounts that have the job function policy arn:aws:iam::aws:policy/job-function/DataScientist | string | `iam_role_for_cross_account_data_scientist` | no |
| role-name-for-cross-account-database-administrator | Name of the IAM role in other child AWS accounts that have the job function policy arn:aws:iam::aws:policy/job-function/DatabaseAdministrator | string | `iam_role_for_cross_account_database_administrator` | no |
| role-name-for-cross-account-network-administrator | Name of the IAM role in other child AWS accounts that have the job function policy arn:aws:iam::aws:policy/job-function/NetworkAdministrator | string | `iam_role_for_cross_account_network_administrator` | no |
| role-name-for-cross-account-power-user-access | Name of the IAM role in other child AWS accounts that have the job function policy arn:aws:iam::aws:policy/PowerUserAccess | string | `iam_role_for_cross_account_power_user_access` | no |
| role-name-for-cross-account-security-audit | Name of the IAM role in other child AWS accounts that have the job function policy arn:aws:iam::aws:policy/SecurityAudit | string | `iam_role_for_cross_account_security_audit` | no |
| role-name-for-cross-account-support-user | Name of the IAM role in other child AWS accounts that have the job function policy arn:aws:iam::aws:policy/job-function/SupportUser | string | `iam_role_for_cross_account_support_user` | no |
| role-name-for-cross-account-system-administrator | Name of the IAM role in other child AWS accounts that have the job function policy arn:aws:iam::aws:policy/job-function/SystemAdministrator | string| `iam_role_for_cross_account_system_administrator` | no |
| role-name-for-cross-account-view-only-access | Name of the IAM role in other child AWS accounts that have the job function policy arn:aws:iam::aws:policy/job-function/ViewOnlyAccess | string | `iam_role_for_cross_account_view_only_access` | no |
| role-name-for-devops-cross-account-administrator-access | Name of the IAM role in other child AWS accounts that have the job function policy arn:aws:iam::aws:policy/AdministratorAccess | string | `iam_role_for_devops_cross_account_administrator_access` | no |
| role-name-for-devops-cross-account-billing | Name of the IAM role in other child AWS accounts that have the job function policy arn:aws:iam::aws:policy/job-function/Billing | string | `iam_role_for_devops_cross_account_billing` | no |
| role-name-for-devops-cross-account-data-scientist | Name of the IAM role in other child AWS accounts that have the job function policy arn:aws:iam::aws:policy/job-function/DataScientist | string | `iam_role_for_devops_cross_account_data_scientist` | no |
| role-name-for-devops-cross-account-database-administrator | Name of the IAM role in other child AWS accounts that have the job function policy arn:aws:iam::aws:policy/job-function/DatabaseAdministrator | string | `iam_role_for_devops_cross_account_database_administrator` | no |
| role-name-for-devops-cross-account-network-administrator | Name of the IAM role in other child AWS accounts that have the job function policy arn:aws:iam::aws:policy/job-function/NetworkAdministrator | string | `iam_role_for_devops_cross_account_network_administrator` | no |
| role-name-for-devops-cross-account-power-user-access | Name of the IAM role in other child AWS accounts that have the job function policy arn:aws:iam::aws:policy/PowerUserAccess | string | `iam_role_for_devops_cross_account_power_user_access` | no |
| role-name-for-devops-cross-account-security-audit | Name of the IAM role in other child AWS accounts that have the job function policy arn:aws:iam::aws:policy/SecurityAudit | string | `iam_role_for_devops_cross_account_security_audit` | no |
| role-name-for-devops-cross-account-support-user | Name of the IAM role in other child AWS accounts that have the job function policy arn:aws:iam::aws:policy/job-function/SupportUser | string | `iam_role_for_devops_cross_account_support_user` | no |
| role-name-for-devops-cross-account-system-administrator | Name of the IAM role in other child AWS accounts that have the job function policy arn:aws:iam::aws:policy/job-function/SystemAdministrator | string | `iam_role_for_devops_cross_account_system_administrator` | no |
| role-name-for-devops-cross-account-view-only-access | Name of the IAM role in other child AWS accounts that have the job function policy arn:aws:iam::aws:policy/job-function/ViewOnlyAccess | string | `iam_role_for_devops_cross_account_view_only_access` | no |

## Outputs

| Name | Description |
|------|-------------|
| aws_account_id | AWS account ID of the account you've applied this module to |
| iam_group_for_administrator_access | ARN of iam_group_for_administrator_access (for use by client / project team only) |
| iam_group_for_billing | ARN of iam_group_for_billing (for use by client / project team only) |
| iam_group_for_cross_account_administrator_access | ARN of iam_group_for_cross_account_administrator_access (for use by client / project team only) |
| iam_group_for_cross_account_billing | ARN of iam_group_for_cross_account_billing (for use by client / project team only) |
| iam_group_for_cross_account_data_scientist | ARN of iam_group_for_cross_account_data_scientist (for use by client / project team only) |
| iam_group_for_cross_account_database_administrator | ARN of iam_group_for_cross_account_database_administrator (for use by client / project team only) |
| iam_group_for_cross_account_network_administrator | ARN of iam_group_for_cross_account_network_administrator (for use by client / project team only) |
| iam_group_for_cross_account_power_user_access | ARN of iam_group_for_cross_account_power_user_access (for use by client / project team only) |
| iam_group_for_cross_account_security_audit | ARN of iam_group_for_cross_account_security_audit (for use by client / project team only) |
| iam_group_for_cross_account_support_user | ARN of iam_group_for_cross_account_support_user (for use by client / project team only) |
| iam_group_for_cross_account_system_administrator | ARN of iam_group_for_cross_account_system_administrator (for use by client / project team only) |
| iam_group_for_cross_account_view_only_access | ARN of iam_group_for_cross_account_view_only_access (for use by client / project team only) |
| iam_group_for_data_scientist | ARN of iam_group_for_data_scientist (for use by client / project team only) |
| iam_group_for_database_administrator | ARN of iam_group_for_database_administrator (for use by client / project team only) |
| iam_group_for_network_administrator | ARN of iam_group_for_network_administrator (for use by client / project team only) |
| iam_group_for_power_user_access | ARN of iam_group_for_power_user_access (for use by client / project team only) |
| iam_group_for_security_audit | ARN of iam_group_for_security_audit (for use by client / project team only) |
| iam_group_for_support_user | ARN of iam_group_for_support_user (for use by client / project team only) |
| iam_group_for_system_administrator | ARN of iam_group_for_system_administrator (for use by client / project team only) |
| iam_group_for_view_only_access | ARN of iam_group_for_view_only_access (for use by client / project team only) |
| iam_role_for_devops_cross_account_administrator_access | ARN of iam_role_for_devops_cross_account_administrator_access (for use by DevOps team only) |
| iam_role_for_devops_cross_account_billing | ARN of iam_role_for_devops_cross_account_billing (for use by DevOps team only) |
| iam_role_for_devops_cross_account_data_scientist | ARN of iam_role_for_devops_cross_account_data_scientist (for use by DevOps team only) |
| iam_role_for_devops_cross_account_database_administrator | ARN of iam_role_for_devops_cross_account_database_administrator (for use by DevOps team only) |
| iam_role_for_devops_cross_account_network_administrator | ARN of iam_role_for_devops_cross_account_network_administrator (for use by DevOps team only) |
| iam_role_for_devops_cross_account_power_user_access | ARN of iam_role_for_devops_cross_account_power_user_access (for use by DevOps team only) |
| iam_role_for_devops_cross_account_security_audit | ARN of iam_role_for_devops_cross_account_security_audit (for use by DevOps team only) |
| iam_role_for_devops_cross_account_support_user | ARN of iam_role_for_devops_cross_account_support_user (for use by DevOps team only) |
| iam_role_for_devops_cross_account_system_administrator | ARN of iam_role_for_devops_cross_account_system_administrator (for use by DevOps team only) |
| iam_role_for_devops_cross_account_view_only_access | ARN of iam_role_for_devops_cross_account_view_only_access (for use by DevOps team only) |
