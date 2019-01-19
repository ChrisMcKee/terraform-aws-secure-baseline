/** 
 * # secure-bucket
 *
 * Creates a S3 bucket with access logging enabled.
 */

resource "aws_s3_bucket" "access_log" {
  bucket = "${var.log_bucket_name}"

  acl = "log-delivery-write"

  lifecycle_rule {
    id      = "auto-archive"
    enabled = true

    # prefix = "/"

    transition {
      days          = "${var.lifecycle_glacier_transition_days}"
      storage_class = "GLACIER"
    }
  }
}

resource "aws_s3_bucket" "content" {
  bucket = "${var.bucket_name}"

  acl = "private"

  logging = {
    target_bucket = "${aws_s3_bucket.access_log.id}"
  }

  versioning = {
    enabled = true

    # Temporarily disabled due to Terraform issue.
    # https://github.com/terraform-providers/terraform-provider-aws/issues/629
    # mfa_delete = true
  }

  lifecycle_rule {
    id      = "auto-archive"
    enabled = true

    # prefix = "${var.prefix}"

    transition {
      days          = "${var.transition}"
      storage_class = "${var.transition_storage_class}"
    }
    noncurrent_version_transition {
      days          = "${var.noncurrent_version_transition}"
      storage_class = "${var.noncurrent_version_transition_storage_class}"
    }
  }

  lifecycle_rule {
    id      = "auto-expire"
    enabled = "${var.enable_expiration}"

    # prefix = "${var.prefix}"

    expiration {
      days = "${var.expiration}"
    }
    noncurrent_version_expiration {
      days = "${var.noncurrent_version_expiration}"
    }
  }

  replication_configuration {
    role = "${aws_iam_role.replication.arn}"

    rules {
      id = "replication"

      # prefix = "${var.replication_prefix}"
      status = "${var.replication_status}"

      source_selection_criteria {
        sse_kms_encrypted_objects {
          enabled = true
        }
      }

      destination {
        bucket             = "${var.destination_bucket_arn}"
        replica_kms_key_id = "${var.destination_replica_kms_key_id}"
      }
    }
  }
}
