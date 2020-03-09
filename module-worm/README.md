## Features

The [module-worm] module is for use with a logging AWS account to receive logs from multiple child AWS accounts. The module was inspired by the AWS Security Blog post: https://aws.amazon.com/blogs/security/how-to-facilitate-data-analysis-and-fulfill-security-requirements-by-using-centralized-flow-log-data/. This module is intended to be more flexible than AWS' solution in terms of being able to be used with multiple AWS accounts and multiple VPCs without any resource clashes (names etc.)

This module will set up all the necessary resources in the logging account so that it is ready to **receive** logs from child accounts. The module [module-child-cloudwatch-connector] should be used in child accounts to facilitate the **sending** of CloudWatch Log events.

This module sets up the following:

* For the given AWS logging account:
    * S3 bucket used as the WORM (write-once-read-many) drive where logs for each AWS child account will send their CloudWatch Log events
    * Kinesis Firehose delivery stream to receive logs from the child account to be sent to S3 bucket
    * Lambda function attached to the above Kinesis Firehose delivery stream to process incoming CloudWatch logs events before being sent to S3
    * CloudWatch logs destination and associated policies for the child account to send logs

The term 'child-account' in this module refers to any AWS account that contains CloudWatch Log groups that you want to collect in the logging account (this can also be the logging account itself).

The term 'logging-account' in this module refers to an AWS account that is designated for the use of collecting logs, it should be the account that fulfills the role of logging for all other AWS child accounts.

## How this module works

* Example of sending VPC flow logs from a child account to logging account's WORM drive:
    * Child account sets up VPC flow logs for a given VPC
    * Child account records VPC flog logs in CloudWatch Log Group (in it's own account)
    * Child account sends the CloudWatch Log events to a CloudWatch Logs Subscription Filter
    * Child account's CloudWatch Logs Subscription Filter sends logs events to logging account's CloudWatch Logs Destination
    * Logging account's CloudWatch Logs Destination is associated with a Kineses Firehose Delivery Stream, the stream receives the CloudWatch Log events from the child account
    * Logging account's Kineses Firehose Delivery Stream invokes a Lambda function to process incoming CloudWatch Log events, this extracts individual log events from records sent by the child account's CloudWatch subscription filter.
    * Logging account's Kineses Firehose Delivery Stream sends the processed CloudWatch Log events to the designated S3 bucket (WORM drive)

![diagram.png](https://github.org/merps/terraform-modules/raw/master/module-worm/diagram.png)

## Usage

The scenario below depicts use of the module with 5 AWS accounts belonging to the same project:
* Central Auth (named 'central')
* Logging (named 'logging')
* Master Biller (named 'master')
* Shared Services (named 'shared')
* Production (named 'prod')

For each of the above accounts, we are using the module to record VPC flow logs for the default VPC in ap-southeast-2.

Example directory structure:
```
myproject
├── environments
│   └── central
│   │  └── main.tf
│   ├── logging
│   │  └── main.tf
│   ├── master
│   │  └── main.tf
│   └── shared
│      └── main.tf
├── global
│   └── modules
│      └── module-worm
```

/myproject/environments/logging/main.tf:
```
  # Setup providers

  # Logging account
  provider "aws" {
    profile = "myproject_central"
    region  = "ap-southeast-2"
    alias   = "myproject_central_ap_southeast_2"
  }

  # WORM for AWS central auth account
  module "logging_worm_drive_for_central" {
    source = "../../modules/module-worm"

    child-account-id     = "${var.central-account-id}"
    child-project        = "myproject"
    child-account-env    = "central"
    child-account-region = "ap-southeast-2"

    providers = {
        "aws" = "aws.myproject_central_ap_southeast_2"
    }
  }
  
  # WORM for AWS logging account
  module "logging_worm_drive_for_logging" {
    source = "../../modules/module-worm"

    child-account-id     = "${var.logging-account-id}"
    child-project        = "myproject"
    child-account-env    = "logging"
    child-account-region = "ap-southeast-2"

    providers = {
        "aws" = "aws.myproject_logging_ap_southeast_2"
    }
  }

  # WORM for AWS master biller account
  module "logging_worm_drive_for_master" {
    source = "../../modules/module-worm"

    child-account-id     = "${var.master-account-id}"
    child-project        = "myproject"
    child-account-env    = "master"
    child-account-region = "ap-southeast-2"

    providers = {
        "aws" = "aws.myproject_master_ap_southeast_2"
    }
  }

  # WORM for AWS shared services account
  module "logging_worm_drive_for_shared" {
    source = "../../modules/module-worm"

    child-account-id     = "${var.shared-account-id}"
    child-project        = "myproject"
    child-account-env    = "shared"
    child-account-region = "ap-southeast-2"

    providers = {
        "aws" = "aws.myproject_shared_ap_southeast_2"
    }
  }
```
