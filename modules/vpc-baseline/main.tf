data "aws_availability_zones" "available" {}

# --------------------------------------------------------------------------------------------------
# Clears rules associated with default resources.
# --------------------------------------------------------------------------------------------------

resource "aws_default_vpc" "default" {
  tags {
    Name = "Default VPC"
  }
}

resource "aws_default_route_table" "default" {
  default_route_table_id = "${aws_default_vpc.default.default_route_table_id}"

  tags {
    Name = "Default Route Table"
  }
}

resource "aws_default_subnet" "default" {
  count = "${length(data.aws_availability_zones.available.names)}"

  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
}

// Ignore "subnet_ids" changes to avoid the known issue below.
// https://github.com/hashicorp/terraform/issues/9824
// https://github.com/terraform-providers/terraform-provider-aws/issues/346
resource "aws_default_network_acl" "default" {
  lifecycle {
    ignore_changes = ["subnet_ids"]
  }

  default_network_acl_id = "${aws_default_vpc.default.default_network_acl_id}"

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags {
    Name = "Default Network ACL"
  }
}

resource "aws_default_security_group" "default" {
  vpc_id = "${aws_default_vpc.default.id}"

  tags {
    Name = "Default Security Group"
  }
}

# --------------------------------------------------------------------------------------------------
# Enable VPC Flow Logs for the default VPC.
# --------------------------------------------------------------------------------------------------

resource "aws_flow_log" "default_vpc_flow_logs" {
  log_destination = "${var.vpc_flow_logs_group_arn}"
  iam_role_arn    = "${var.vpc_flow_logs_iam_role_arn}"
  vpc_id          = "${aws_default_vpc.default.id}"
  traffic_type    = "ALL"
}
