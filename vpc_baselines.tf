# --------------------------------------------------------------------------------------------------
# Create an IAM Role for publishing VPC Flow Logs into CloudWatch Logs group.
# Reference: https://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/flow-logs.html#flow-logs-iam
# --------------------------------------------------------------------------------------------------

resource "aws_iam_role" "vpc_flow_logs_publisher" {
  name = "${var.vpc_iam_role_name}"

  assume_role_policy = <<END_OF_POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
END_OF_POLICY
}

resource "aws_iam_role_policy" "vpc_flow_logs_publish_policy" {
  name = "${var.vpc_iam_role_policy_name}"
  role = "${aws_iam_role.vpc_flow_logs_publisher.id}"

  policy = <<END_OF_POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
END_OF_POLICY
}

resource "aws_cloudwatch_log_group" "default_vpc_flow_logs" {
  name              = "${var.vpc_log_group_name}"
  retention_in_days = "${var.vpc_log_retention_in_days}"
}

# --------------------------------------------------------------------------------------------------
# VPC Baseline
# Needs to be set up in each region.
# --------------------------------------------------------------------------------------------------

module "vpc_baseline_ap-northeast-1" {
  source                     = "./modules/vpc-baseline"
  vpc_flow_logs_group_arn    = "arn:aws:logs:ap-northeast-1:${var.aws_account_id}:log-group:${var.vpc_log_group_name}:*"
  vpc_flow_logs_iam_role_arn = "${aws_iam_role.vpc_flow_logs_publisher.arn}"

  providers = {
    aws = "aws.ap-northeast-1"
  }
}

module "vpc_baseline_ap-northeast-2" {
  source                     = "./modules/vpc-baseline"
  vpc_flow_logs_group_arn    = "arn:aws:logs:ap-northeast-2:${var.aws_account_id}:log-group:${var.vpc_log_group_name}:*"
  vpc_flow_logs_iam_role_arn = "${aws_iam_role.vpc_flow_logs_publisher.arn}"

  providers = {
    aws = "aws.ap-northeast-2"
  }
}

module "vpc_baseline_ap-south-1" {
  source                     = "./modules/vpc-baseline"
  vpc_flow_logs_group_arn    = "arn:aws:logs:ap-south-1:${var.aws_account_id}:log-group:${var.vpc_log_group_name}:*"
  vpc_flow_logs_iam_role_arn = "${aws_iam_role.vpc_flow_logs_publisher.arn}"

  providers = {
    aws = "aws.ap-south-1"
  }
}

module "vpc_baseline_ap-southeast-1" {
  source                     = "./modules/vpc-baseline"
  vpc_flow_logs_group_arn    = "arn:aws:logs:ap-southeast-1:${var.aws_account_id}:log-group:${var.vpc_log_group_name}:*"
  vpc_flow_logs_iam_role_arn = "${aws_iam_role.vpc_flow_logs_publisher.arn}"

  providers = {
    aws = "aws.ap-southeast-1"
  }
}

module "vpc_baseline_ap-southeast-2" {
  source                     = "./modules/vpc-baseline"
  vpc_flow_logs_group_arn    = "arn:aws:logs:ap-southeast-2:${var.aws_account_id}:log-group:${var.vpc_log_group_name}:*"
  vpc_flow_logs_iam_role_arn = "${aws_iam_role.vpc_flow_logs_publisher.arn}"

  providers = {
    aws = "aws.ap-southeast-2"
  }
}

module "vpc_baseline_ca-central-1" {
  source                     = "./modules/vpc-baseline"
  vpc_flow_logs_group_arn    = "arn:aws:logs:ca-central-1:${var.aws_account_id}:log-group:${var.vpc_log_group_name}:*"
  vpc_flow_logs_iam_role_arn = "${aws_iam_role.vpc_flow_logs_publisher.arn}"

  providers = {
    aws = "aws.ca-central-1"
  }
}

module "vpc_baseline_eu-central-1" {
  source                     = "./modules/vpc-baseline"
  vpc_flow_logs_group_arn    = "arn:aws:logs:eu-central-1:${var.aws_account_id}:log-group:${var.vpc_log_group_name}:*"
  vpc_flow_logs_iam_role_arn = "${aws_iam_role.vpc_flow_logs_publisher.arn}"

  providers = {
    aws = "aws.eu-central-1"
  }
}

module "vpc_baseline_eu-north-1" {
  source                     = "./modules/vpc-baseline"
  vpc_flow_logs_group_arn    = "arn:aws:logs:eu-north-1:${var.aws_account_id}:log-group:${var.vpc_log_group_name}:*"
  vpc_flow_logs_iam_role_arn = "${aws_iam_role.vpc_flow_logs_publisher.arn}"

  providers = {
    aws = "aws.eu-north-1"
  }
}
module "vpc_baseline_eu-west-1" {
  source                     = "./modules/vpc-baseline"
  vpc_flow_logs_group_arn    = "arn:aws:logs:eu-west-1:${var.aws_account_id}:log-group:${var.vpc_log_group_name}:*"
  vpc_flow_logs_iam_role_arn = "${aws_iam_role.vpc_flow_logs_publisher.arn}"

  providers = {
    aws = "aws.eu-west-1"
  }
}

module "vpc_baseline_eu-west-2" {
  source                     = "./modules/vpc-baseline"
  vpc_flow_logs_group_arn    = "arn:aws:logs:eu-west-2:${var.aws_account_id}:log-group:${var.vpc_log_group_name}:*"
  vpc_flow_logs_iam_role_arn = "${aws_iam_role.vpc_flow_logs_publisher.arn}"

  providers = {
    aws = "aws.eu-west-2"
  }
}

module "vpc_baseline_eu-west-3" {
  source                     = "./modules/vpc-baseline"
  vpc_flow_logs_group_arn    = "arn:aws:logs:eu-west-3:${var.aws_account_id}:log-group:${var.vpc_log_group_name}:*"
  vpc_flow_logs_iam_role_arn = "${aws_iam_role.vpc_flow_logs_publisher.arn}"

  providers = {
    aws = "aws.eu-west-3"
  }
}

module "vpc_baseline_sa-east-1" {
  source                     = "./modules/vpc-baseline"
  vpc_flow_logs_group_arn    = "arn:aws:logs:sa-east-1:${var.aws_account_id}:log-group:${var.vpc_log_group_name}:*"
  vpc_flow_logs_iam_role_arn = "${aws_iam_role.vpc_flow_logs_publisher.arn}"

  providers = {
    aws = "aws.sa-east-1"
  }
}

module "vpc_baseline_us-east-1" {
  source                     = "./modules/vpc-baseline"
  vpc_flow_logs_group_arn    = "arn:aws:logs:us-east-1:${var.aws_account_id}:log-group:${var.vpc_log_group_name}:*"
  vpc_flow_logs_iam_role_arn = "${aws_iam_role.vpc_flow_logs_publisher.arn}"

  providers = {
    aws = "aws.us-east-1"
  }
}

module "vpc_baseline_us-east-2" {
  source                     = "./modules/vpc-baseline"
  vpc_flow_logs_group_arn    = "arn:aws:logs:us-east-2:${var.aws_account_id}:log-group:${var.vpc_log_group_name}:*"
  vpc_flow_logs_iam_role_arn = "${aws_iam_role.vpc_flow_logs_publisher.arn}"

  providers = {
    aws = "aws.us-east-2"
  }
}

module "vpc_baseline_us-west-1" {
  source                     = "./modules/vpc-baseline"
  vpc_flow_logs_group_arn    = "arn:aws:logs:us-west-1:${var.aws_account_id}:log-group:${var.vpc_log_group_name}:*"
  vpc_flow_logs_iam_role_arn = "${aws_iam_role.vpc_flow_logs_publisher.arn}"

  providers = {
    aws = "aws.us-west-1"
  }
}

module "vpc_baseline_us-west-2" {
  source                     = "./modules/vpc-baseline"
  vpc_flow_logs_group_arn    = "arn:aws:logs:us-west-2:${var.aws_account_id}:log-group:${var.vpc_log_group_name}:*"
  vpc_flow_logs_iam_role_arn = "${aws_iam_role.vpc_flow_logs_publisher.arn}"

  providers = {
    aws = "aws.us-west-2"
  }
}
