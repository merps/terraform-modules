## Features

The [child-iam] module is for use with a child AWS account to set up the following:

- IAM trust policy to allow DevOps team to assume roles in this account from DevOps central auth account (defaults to [master-central])
- IAM roles that utilise AWS-managed job function role policies for DevOps team
- IAM trust policy to allow client / project team to assume roles in this account from their own central auth account
- IAM roles that utilise AWS-managed job function role policies for client / project team

The term 'child' in this module refers to any AWS account that is **NOT** used for centralised authentication purposes, for example this module would be suitable for use with any project's prod / nonprod / logging AWS account but not for any AWS accounts that contains IAM users or IAM groups (which is effectively the 'parent' account for authentication purposes)

## How this module works

* This module creates the following for a given child AWS account:
    * IAM trust policy that allows [master-central-auth] account to assume roles into the given child AWS account
    * IAM roles that can be assumed via the [master-central-auth] account
    * IAM access policies that allow roles to be assumed by the given [client-auth-account-id] AWS account
    * IAM roles that correspond to AWS-managed job function permissions for the child account

## Usage

The following example is for deploying the module inside of a project's production environment [main.tf] file, it is assumed that you have the account ID of the client's central auth account.

\prod\main.tf:
```
    variable project_central_auth_account = "111111111111"

    provider "aws" {
        profile = "project_prod"
        region  = "ap-southeast-2"
    }

    module "prod_iam" {
        source                 = "/module-child-iam"
        client-auth-account-id = "${var.project_central_auth_account}"
        
        providers = {
            "aws" = "aws.project_prod"
        }
    }
```

The following example is for deploying the module inside of a project's logging environment main.tf file, it is assumed that you have the account ID of the client's central auth account. Note that the use of the word 'child' is relative, instead of applying to the production environment like the previous example, you're applying the exact same module here but to a different AWS account (being the logging account this time).

\logging\main.tf:
```
    variable project_central_auth_account = "111111111111"

    provider "aws" {
        profile = "project_logging"
        region  = "ap-southeast-2"
    }

    module "logging_iam" {
        source                 = "/module-child-iam"
        client-auth-account-id = "${var.project_central_auth_account}"
        
        providers = {
            "aws" = "aws.project_logging"
        }
    }
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| client-auth-account-id | Account ID of the client / project's central auth AWS account. | string | - | yes |
| ddevops-auth-account-id | Account ID of the DDevOps central auth AWS account, defaults to account id of [master-central-auth]. | string | `123456789` | no |
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
| role-name-for-cross-account-administrator-access | Name of the IAM role that have the job function policy arn:aws:iam::aws:policy/AdministratorAccess | string | `iam_role_for_cross_account_administrator_access` | no |
| role-name-for-cross-account-billing | Name of the IAM role that have the job function policy arn:aws:iam::aws:policy/job-function/Billing | string | `iam_role_for_cross_account_billing` | no |
| role-name-for-cross-account-data-scientist | Name of the IAM role that have the job function policy arn:aws:iam::aws:policy/job-function/DataScientist | string | `iam_role_for_cross_account_data_scientist` | no |
| role-name-for-cross-account-database-administrator | Name of the IAM role that have the job function policy arn:aws:iam::aws:policy/job-function/DatabaseAdministrator | string | `iam_role_for_cross_account_database_administrator` | no |
| role-name-for-cross-account-network-administrator | Name of the IAM role that have the job function policy arn:aws:iam::aws:policy/job-function/NetworkAdministrator | string | `iam_role_for_cross_account_network_administrator` | no |
| role-name-for-cross-account-power-user-access | Name of the IAM role that have the job function policy arn:aws:iam::aws:policy/PowerUserAccess | string | `iam_role_for_cross_account_power_user_access` | no |
| role-name-for-cross-account-security-audit | Name of the IAM role that have the job function policy arn:aws:iam::aws:policy/SecurityAudit | string | `iam_role_for_cross_account_security_audit` | no |
| role-name-for-cross-account-support-user | Name of the IAM role that have the job function policy arn:aws:iam::aws:policy/job-function/SupportUser | string | `iam_role_for_cross_account_support_user`| no |
| role-name-for-cross-account-system-administrator | Name of the IAM role that have the job function policy arn:aws:iam::aws:policy/job-function/SystemAdministrator | string | `iam_role_for_cross_account_system_administrator` | no |
| role-name-for-cross-account-view-only-access | Name of the IAM role that have the job function policy arn:aws:iam::aws:policy/job-function/ViewOnlyAccess | string | `iam_role_for_cross_account_view_only_access` | no |
| role-name-for-devops-cross-account-administrator-access | Name of the IAM role that have the job function policy arn:aws:iam::aws:policy/AdministratorAccess | string | `iam_role_for_devops_cross_account_administrator_access` | no |
| role-name-for-devops-cross-account-billing | Name of the IAM role that have the job function policy arn:aws:iam::aws:policy/job-function/Billing | string | `iam_role_for_devops_cross_account_billing` | no |
| role-name-for-devops-cross-account-data-scientist | Name of the IAM role that have the job function policy arn:aws:iam::aws:policy/job-function/DataScientist | string | `iam_role_for_devops_cross_account_data_scientist` | no |
| role-name-for-devops-cross-account-database-administrator | Name of the IAM role that have the job function policy arn:aws:iam::aws:policy/job-function/DatabaseAdministrator | string | `iam_role_for_devops_cross_account_database_administrator` | no |
| role-name-for-devops-cross-account-network-administrator | Name of the IAM role that have the job function policy arn:aws:iam::aws:policy/job-function/NetworkAdministrator | string | `iam_role_for_devops_cross_account_network_administrator` | no |
| role-name-for-devops-cross-account-power-user-access | Name of the IAM role that have the job function policy arn:aws:iam::aws:policy/PowerUserAccess | string | `iam_role_for_devops_cross_account_power_user_access` | no |
| role-name-for-devops-cross-account-security-audit | Name of the IAM role that have the job function policy arn:aws:iam::aws:policy/SecurityAudit | string | `iam_role_for_devops_cross_account_security_audit` | no |
| role-name-for-devops-cross-account-support-user | Name of the IAM role that have the job function policy arn:aws:iam::aws:policy/job-function/SupportUser | string | `iam_role_for_devops_cross_account_support_user` | no |
| role-name-for-devops-cross-account-system-administrator | Name of the IAM role that have the job function policy arn:aws:iam::aws:policy/job-function/SystemAdministrator | string | `iam_role_for_devops_cross_account_system_administrator` | no |
| role-name-for-devops-cross-account-view-only-access | Name of the IAM role that have the job function policy arn:aws:iam::aws:policy/job-function/ViewOnlyAccess | string | `iam_role_for_devops_cross_account_view_only_access` | no |

## Outputs

| Name | Description |
|------|-------------|
| aws_account_id | AWS account ID of the account you've applied this module to |
| iam_role_for_cross_account_administrator_access | ARN of iam_role_for_cross_account_administrator_access (for use by client / project team only) |
| iam_role_for_cross_account_billing | ARN of iam_role_for_cross_account_billing (for use by client / project team only) |
| iam_role_for_cross_account_data_scientist | ARN of iam_role_for_cross_account_data_scientist (for use by client / project team only) |
| iam_role_for_cross_account_database_administrator | ARN of iam_role_for_cross_account_database_administrator (for use by client / project team only) |
| iam_role_for_cross_account_network_administrator | ARN of iam_role_for_cross_account_network_administrator (for use by client / project team only) |
| iam_role_for_cross_account_power_user_access | ARN of iam_role_for_cross_account_power_user_access (for use by client / project team only) |
| iam_role_for_cross_account_security_audit | ARN of iam_role_for_cross_account_security_audit (for use by client / project team only) |
| iam_role_for_cross_account_support_user | ARN of iam_role_for_cross_account_support_user (for use by client / project team only) |
| iam_role_for_cross_account_system_administrator | ARN of iam_role_for_cross_account_system_administrator (for use by client / project team only) |
| iam_role_for_cross_account_view_only_access | ARN of iam_role_for_cross_account_view_only_access (for use by client / project team only) |
| iam_role_for_devops_cross_account_administrator_access | ARN of iam_role_for_devops_cross_account_administrator_access (for use by DevOps team only) |
<<<<<<< HEAD
| iam_role_for_devops_cross_account_billing | ARN of iam_role_for_devops_cross_account_billing (for use by DevOps team only) |
| iam_role_for_devops_cross_account_data_scientist | ARN of iam_role_for_devops_cross_account_data_scientist (for use by DevOps team only) |
| iam_role_for_devops_cross_account_database_administrator | ARN of iam_role_for_devops_cross_account_database_administrator (for use by DevOps team only) |
| iam_role_for_devops_cross_account_network_administrator | ARN of iam_role_for_devops_cross_account_network_administrator (for use by DevOps team only) |
| iam_role_for_devops_cross_account_power_user_access | ARN of iam_role_for_devops_cross_account_power_user_access (for use by DevOps team only) |
| iam_role_for_devops_cross_account_security_audit | ARN of iam_role_for_devops_cross_account_security_audit (for use by DevOps team only) |
| iam_role_for_devops_cross_account_support_user | ARN of iam_role_for_devops_cross_account_support_user (for use by DevOps team only) |
| iam_role_for_devops_cross_account_system_administrator | ARN of iam_role_for_devops_cross_account_system_administrator (for use by DevOps team only) |
| iam_role_for_devops_cross_account_view_only_access | ARN of iam_role_for_devops_cross_account_view_only_access (for use by DevOps team only) |
=======
| iam_role_for_devops_cross_account_billing | ARN of iam_role_for_ddevops_cross_account_billing (for use by DDevOps team only) |
| iam_role_for_devops_cross_account_data_scientist | ARN of iam_role_for_ddevops_cross_account_data_scientist (for use by DDevOps team only) |
| iam_role_for_devops_cross_account_database_administrator | ARN of iam_role_for_devops_cross_account_database_administrator (for use by DevOps team only) |
| iam_role_for_devops_cross_account_network_administrator | ARN of iam_role_for_ddevops_cross_account_network_administrator (for use by DevOps team only) |
| iam_role_for_ddevops_cross_account_power_user_access | ARN of iam_role_for_devops_cross_account_power_user_access (for use by DevOps team only) |
| iam_role_for_ddevops_cross_account_security_audit | ARN of iam_role_for_devops_cross_account_security_audit (for use by DevOps team only) |
| iam_role_for_ddevops_cross_account_support_user | ARN of iam_role_for_devops_cross_account_support_user (for use by DevOps team only) |
| iam_role_for_devops_cross_account_system_administrator | ARN of iam_role_for_devops_cross_account_system_administrator (for use by DevOps team only) |
| iam_role_for_devops_cross_account_view_only_access | ARN of iam_role_for_devops_cross_account_view_only_access (for use by DevOps team only) |
>>>>>>> de095a4c56851c831d404a666fe8c025e2b8a7b7
