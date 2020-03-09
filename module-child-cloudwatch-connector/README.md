## Features

The [module-child-cloudwatch-connector] module is for use with a child AWS account to send logs to a logging AWS account. The module was inspired by the AWS Security Blog post: https://aws.amazon.com/blogs/security/how-to-facilitate-data-analysis-and-fulfill-security-requirements-by-using-centralized-flow-log-data/

The module [module-child-cloudwatch-connector] should be used in child accounts to facilitate the **sending** of CloudWatch Log events whereas the [module-worm] module will set up all the necessary resources in the logging account so that it is ready to **receive** logs from child accounts.

This module sets up the following:

* For the given AWS child account:
    * A CloudWatch Log Subscription Filter for each user-provided CloudWatch Log Group
    * Each given CloudWatch Log Group will be sent to the logging account's CloudWatch Log Destination
    * The logging account's CloudWatch Log Destination will then receice all incoming log events via a Kinesis Firehose Delivery Stream, processed via a Lambda function, then sent to the logging account's WORM drive

## How this module works

* Example of sending VPC flow logs from a child account to logging account's WORM drive:
    * Child account sets up VPC flow logs for a given VPC
    * Child account records VPC flog logs in CloudWatch Log Group (in it's own account)
    * Child account sends the CloudWatch Log events to a CloudWatch Logs Subscription Filter
    * Child account's CloudWatch Logs Subscription Filter sends logs events to logging account's CloudWatch Logs Destination
    * Logging account's CloudWatch Logs Destination is associated with a Kineses Firehose Delivery Stream, the stream receives the CloudWatch Log events from the child account
    * Logging account's Kineses Firehose Delivery Stream invokes a Lambda function to process incoming CloudWatch Log events, this extracts individual log events from records sent by the child account's CloudWatch subscription filter.
    * Logging account's Kineses Firehose Delivery Stream sends the processed CloudWatch Log events to the designated S3 bucket (WORM drive)

![diagram.png](https://bitbucket.org/strutdigital/s-toolbox/raw/master/terraform/module-child-cloudwatch-connector/diagram.png)

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

/myproject/environments/central/main.tf:
```
  # Setup providers

  # Central Auth account
  provider "aws" {
    profile = "myproject_central"
    region  = "ap-southeast-2"
    alias   = "myproject_central_ap_southeast_2"
  }

  module "central_send_logs_to_logging_account_worm_drive" {
    source                                         = "../../global/modules/module-child-cloudwatch-connector"
    child-project                                  = "myproject"
    child-account-env                              = "central"
    child-cloudwatch-log-group-count               = 3
    child-cloudwatch-log-group-names               = [
        "cloudwatch-log-group-1-name",
        "cloudwatch-log-group-2-name",
        "cloudwatch-log-group-3-name"
    ]
    child-cloudwatch-log-filter-pattern            = ""
    logging-account-cloudwatch-log-destination-arn = "arn:aws:logs:ap-southeast-2:123456789012:destination:myproject-aws-compliance-central-destination"
  }
```

/myproject/environments/logging/main.tf:
```
  # Setup providers

  # Logging account
  provider "aws" {
    profile = "myproject_logging"
    region  = "ap-southeast-2"
    alias   = "myproject_logging_ap_southeast_2"
  }

  module "logging_send_logs_to_logging_account_worm_drive" {
    source                                         = "../../global/modules/module-child-cloudwatch-connector"
    child-project                                  = "myproject"
    child-account-env                              = "logging"
    child-cloudwatch-log-group-count               = 3
    child-cloudwatch-log-group-names               = [
        "cloudwatch-log-group-1-name",
        "cloudwatch-log-group-2-name",
        "cloudwatch-log-group-3-name"
    ]
    child-cloudwatch-log-filter-pattern            = ""
    logging-account-cloudwatch-log-destination-arn = "arn:aws:logs:ap-southeast-2:123456789012:destination:myproject-aws-compliance-logging-destination"
  }
```

/myproject/environments/master/main.tf:
```
  # Setup providers

  # Master Biller account
  provider "aws" {
    profile = "myproject_master"
    region  = "ap-southeast-2"
    alias   = "myproject_master_ap_southeast_2"
  }

  module "master_send_logs_to_logging_account_worm_drive" {
    source                                         = "../../global/modules/module-child-cloudwatch-connector"
    child-project                                  = "myproject"
    child-account-env                              = "master"
    child-cloudwatch-log-group-count               = 3
    child-cloudwatch-log-group-names               = [
        "cloudwatch-log-group-1-name",
        "cloudwatch-log-group-2-name",
        "cloudwatch-log-group-3-name"
    ]
    child-cloudwatch-log-filter-pattern            = ""
    logging-account-cloudwatch-log-destination-arn = "arn:aws:logs:ap-southeast-2:123456789012:destination:myproject-aws-compliance-master-destination"
  }
```

/myproject/environments/shared/main.tf:
```
  # Setup providers

  # Shared Services account
  provider "aws" {
    profile = "myproject_shared"
    region  = "ap-southeast-2"
    alias   = "myproject_shared_ap_southeast_2"
  }

  module "shared_send_logs_to_logging_account_worm_drive" {
    source                                         = "../../global/modules/module-child-cloudwatch-connector"
    child-project                                  = "myproject"
    child-account-env                              = "shared"
    child-cloudwatch-log-group-count               = 3
    child-cloudwatch-log-group-names               = [
        "cloudwatch-log-group-1-name",
        "cloudwatch-log-group-2-name",
        "cloudwatch-log-group-3-name"
    ]
    child-cloudwatch-log-filter-pattern            = ""
    logging-account-cloudwatch-log-destination-arn = "arn:aws:logs:ap-southeast-2:123456789012:destination:myproject-aws-compliance-shared-destination"
  }
```