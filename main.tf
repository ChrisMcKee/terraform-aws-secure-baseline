/**
* # terraform-aws-secure-baseline
* 
* [![CircleCI](https://circleci.com/gh/nozaq/terraform-aws-secure-baseline.svg?style=svg)](https://circleci.com/gh/nozaq/terraform-aws-secure-baseline)
*
* [Terraform Module Registry](https://registry.terraform.io/modules/nozaq/secure-baseline/aws)
* 
* A terraform module to set up your AWS account with the reasonably secure configuration baseline.
* Most configurations are based on [CIS Amazon Web Services Foundations] v1.2.0.
* 
* See [Benchmark Compliance](./compliance.md) to check which items in CIS benchmark are covered.
* 
* ## Features
* 
* ### Identity and Access Management
* 
* - Set up IAM Password Policy.
* - Creates separated IAM roles for defining privileges and assigning them to entities such as IAM users and groups.
* - Creates an IAM role for contacting AWS support for incident handling.
* - Enable AWS Config rules to audit root account status.
* 
* ### Logging & Monitoring
* 
* - Enable CloudTrail in all regions and deliver events to CloudWatch Logs.
* - CloudTrail logs are encrypted using AWS Key Management Service.
* - All logs are stored in the S3 bucket with access logging enabled.
* - Logs are automatically archived into Amazon Glacier after the given period(defaults to 90 days).
* - Set up CloudWatch alarms to notify you when critical changes happen in your AWS account.
* - Enable AWS Config in all regions to automatically take configuration snapshots.
* 
* ### Networking
* 
* - Remove all rules associated with default route tables, default network ACLs and default security groups in the default VPC in all regions.
* - Enable AWS Config rules to audit unrestricted common ports in Security Group rules.
* - Enable VPC Flow Logs with the default VPC in all regions.
* - Enable GuardDuty in all regions.
* 
* ## Usage
* 
* ```hcl
* data "aws_caller_identity" "current" {}
* data "aws_region" "current" {}
* 
* module "secure-baseline" {
*   source  = "nozaq/secure-baseline/aws"
* 
*   audit_log_bucket_name = "YOUR_BUCKET_NAME"
*   aws_account_id = "${data.aws_caller_identity.current.account_id}"
*   region = "${data.aws_region.current.name}"
*   support_iam_role_principal_arn = "YOUR_IAM_USER"
* 
*   providers = {
*     "aws"                = "aws"
*     "aws.ap-northeast-1" = "aws.ap-northeast-1"
*     "aws.ap-northeast-2" = "aws.ap-northeast-2"
*     "aws.ap-south-1"     = "aws.ap-south-1"
*     "aws.ap-southeast-1" = "aws.ap-southeast-1"
*     "aws.ap-southeast-2" = "aws.ap-southeast-2"
*     "aws.ap-southeast-2" = "aws.ap-southeast-2"
*     "aws.ca-central-1"   = "aws.ca-central-1"
*     "aws.eu-central-1"   = "aws.eu-central-1"
*     "aws.eu-north-1"      = "aws.eu-north-1"
*     "aws.eu-west-1"      = "aws.eu-west-1"
*     "aws.eu-west-2"      = "aws.eu-west-2"
*     "aws.eu-west-3"      = "aws.eu-west-3"
*     "aws.sa-east-1"      = "aws.sa-east-1"
*     "aws.us-east-1"      = "aws.us-east-1"
*     "aws.us-east-2"      = "aws.us-east-2"
*     "aws.us-west-1"      = "aws.us-west-1"
*     "aws.us-west-2"      = "aws.us-west-2"
*   }
* }
* ```
* 
* Check [the example](./examples/root-example/regions.tf) to understand how these providers are defined.
* Note that you need to define a provider for each AWS region and pass them to the module. Currently this is the recommended way to handle multiple regions in one module.
* Detailed information can be found at [Providers within Modules - Terraform Docs].
* 
* ## Submodules
* 
* This module is composed of several submodules and each of which can be used independently.
* 
* - [alarm-baseline](./modules/alarm-baseline)
* - [cloudtrail-baseline](./modules/cloudtrail-baseline)
* - [guardduty-baseline](./modules/guardduty-baseline)
* - [iam-baseline](./modules/iam-baseline)
* - [vpc-baseline](./modules/vpc-baseline)
* - [secure-bucket](./modules/secure-bucket)
*/

# --------------------------------------------------------------------------------------------------
# Create a S3 bucket to store various audit logs.
# Bucket policies are derived from the default bucket policy described in
# AWS Config Developer Guide and AWS CloudTrail User Guide.
# https://docs.aws.amazon.com/config/latest/developerguide/s3-bucket-policy.html
# https://docs.aws.amazon.com/awscloudtrail/latest/userguide/create-s3-bucket-policy-for-cloudtrail.html
# --------------------------------------------------------------------------------------------------

module "audit_log_bucket" {
  source = "./modules/secure-bucket"

  region                                      = "${var.region}"
  bucket_name                                 = "${var.audit_log_bucket_name}"
  log_bucket_name                             = "${var.audit_log_bucket_name}-access-logs"
  lifecycle_glacier_transition_days           = "${var.audit_log_lifecycle_glacier_transition_days}"
  prefix                                      = "${var.audit_log_prefix}"
  enable_expiration                           = "${var.audit_log_enable_expiration}"
  expiration                                  = "${var.audit_log_expiration}"
  transition                                  = "${var.audit_log_transition}"
  noncurrent_version_expiration               = "${var.audit_log_noncurrent_version_expiration}"
  noncurrent_version_transition               = "${var.audit_log_noncurrent_version_transition}"
  transition_storage_class                    = "${var.audit_log_transition_storage_class}"
  noncurrent_version_transition_storage_class = "${var.audit_log_noncurrent_version_transition_storage_class}"
  replication_status                          = "${var.audit_log_replication_status}"
  replication_prefix                          = "${var.audit_log_replication_prefix}"
  source_kms_key_id                           = "${module.cloudtrail_baseline.kms_key_arn}"
  config_destination_bucket_arn               = "${var.audit_log_config_destination_bucket_arn}"
  cloudtrail_destination_bucket_arn           = "${var.audit_log_cloudtrail_destination_bucket_arn}"
  destination_replica_kms_key_id              = "${var.audit_log_destination_replica_kms_key_id}"
  aws_account_id                              = "${var.aws_account_id}"
}

resource "aws_s3_bucket_policy" "audit_log_bucket_policy" {
  bucket = "${module.audit_log_bucket.this_bucket_id}"

  policy = <<END_OF_POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AWSCloudTrailAclCheckForConfig",
      "Effect": "Allow",
      "Principal": {"Service": "config.amazonaws.com"},
      "Action": "s3:GetBucketAcl",
      "Resource": "${module.audit_log_bucket.this_bucket_arn}"
    },
    {
      "Sid": " AWSCloudTrailWriteForConfig",
      "Effect": "Allow",
      "Principal": {"Service": "config.amazonaws.com"},
      "Action": "s3:PutObject",
      "Resource": "${module.audit_log_bucket.this_bucket_arn}/AWSLogs/${var.aws_account_id}/Config/*",
      "Condition": {"StringEquals": {"s3:x-amz-acl": "bucket-owner-full-control"}}
    },
    {
        "Sid": "AWSCloudTrailAclCheckForCloudTrail",
        "Effect": "Allow",
        "Principal": {
            "Service": "cloudtrail.amazonaws.com"
        },
        "Action": "s3:GetBucketAcl",
        "Resource": "${module.audit_log_bucket.this_bucket_arn}"
    },
    {
        "Sid": "AWSCloudTrailWriteForCloudTrail",
        "Effect": "Allow",
        "Principal": {
            "Service": "cloudtrail.amazonaws.com"
        },
        "Action": "s3:PutObject",
        "Resource": "${module.audit_log_bucket.this_bucket_arn}/AWSLogs/${var.aws_account_id}/*",
        "Condition": {
            "StringEquals": {
                "s3:x-amz-acl": "bucket-owner-full-control"
            }
        }
    }
  ]
}
END_OF_POLICY
}

# --------------------------------------------------------------------------------------------------
# IAM Baseline
# --------------------------------------------------------------------------------------------------

module "iam_baseline" {
  source = "./modules/iam-baseline"

  aws_account_id                 = "${var.aws_account_id}"
  master_iam_role_name           = "${var.master_iam_role_name}"
  master_iam_role_policy_name    = "${var.master_iam_role_policy_name}"
  manager_iam_role_name          = "${var.manager_iam_role_name}"
  manager_iam_role_policy_name   = "${var.manager_iam_role_policy_name}"
  support_iam_role_name          = "${var.support_iam_role_name}"
  support_iam_role_policy_name   = "${var.support_iam_role_policy_name}"
  support_iam_role_principal_arn = "${var.support_iam_role_principal_arn}"
  minimum_password_length        = "${var.minimum_password_length}"
  password_reuse_prevention      = "${var.password_reuse_prevention}"
  require_lowercase_characters   = "${var.require_lowercase_characters}"
  require_numbers                = "${var.require_numbers}"
  require_uppercase_characters   = "${var.require_uppercase_characters}"
  require_symbols                = "${var.require_symbols}"
  allow_users_to_change_password = "${var.allow_users_to_change_password}"
  max_password_age               = "${var.max_password_age}"
}

# --------------------------------------------------------------------------------------------------
# CloudTrail Baseline
# --------------------------------------------------------------------------------------------------

module "cloudtrail_baseline" {
  source = "./modules/cloudtrail-baseline"

  aws_account_id                    = "${var.aws_account_id}"
  cloudtrail_name                   = "${var.cloudtrail_name}"
  cloudwatch_logs_group_name        = "${var.cloudtrail_cloudwatch_logs_group_name}"
  cloudwatch_logs_retention_in_days = "${var.cloudwatch_logs_retention_in_days}"
  iam_role_name                     = "${var.cloudtrail_iam_role_name}"
  iam_role_policy_name              = "${var.cloudtrail_iam_role_policy_name}"
  key_deletion_window_in_days       = "${var.cloudtrail_key_deletion_window_in_days}"
  region                            = "${var.region}"
  s3_bucket_name                    = "${module.audit_log_bucket.this_bucket_id}"
}

# --------------------------------------------------------------------------------------------------
# CloudWatch Alarms Baseline
# --------------------------------------------------------------------------------------------------

module "alarm_baseline" {
  source = "./modules/alarm-baseline"

  alarm_namespace           = "${var.alarm_namespace}"
  cloudtrail_log_group_name = "${module.cloudtrail_baseline.log_group_name}"
  sns_topic_name            = "${var.alarm_sns_topic_name}"
}

# --------------------------------------------------------------------------------------------------
# SecurityHub Baseline
# --------------------------------------------------------------------------------------------------

module "securityhub_baseline" {
  source = "./modules/securityhub-baseline"
}
