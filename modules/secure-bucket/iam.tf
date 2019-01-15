resource "aws_iam_role" "replication" {
  name = "cis_bucket_replication_role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_policy_attachment" "replication" {
  name       = "cis_bucket_replication_attachment"
  roles      = ["${aws_iam_role.replication.name}"]
  policy_arn = "${aws_iam_policy.replication.arn}"
}

resource "aws_iam_policy" "replication" {
  name = "cis_bucket_replication_policy"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:ListBucket",
                "s3:GetReplicationConfiguration",
                "s3:GetObjectVersionForReplication",
                "s3:GetObjectVersionAcl",
                "s3:GetObjectVersionTagging"
            ],
            "Effect": "Allow",
            "Resource": [
                "${aws_s3_bucket.content.arn}",
                "${aws_s3_bucket.content.arn}/*"
            ]
        },
        {
            "Action": [
                "s3:ReplicateObject",
                "s3:ReplicateDelete",
                "s3:ReplicateTags",
                "s3:GetObjectVersionTagging"
            ],
            "Effect": "Allow",
            "Resource": "${var.destination_bucket_arn}/*"
        },
        {
            "Action": [
                "kms:Decrypt"
            ],
            "Effect": "Allow",
            "Condition": {
                "StringLike": {
                    "kms:ViaService": "s3.${var.region}.amazonaws.com",
                    "kms:EncryptionContext:aws:s3:arn": [
                        "arn:aws:s3:::${aws_s3_bucket.content.arn}/*"
                    ]
                }
            },
            "Resource": [
                "${var.source_kms_key_id}"
            ]
        },
        {
            "Action": [
                "kms:*"
            ],
            "Effect": "Allow",
            "Condition": {
                "StringLike": {
                    "kms:ViaService": "s3.${var.destination_region}.amazonaws.com",
                    "kms:EncryptionContext:aws:s3:arn": [
                        "${var.destination_bucket_arn}/*"
                    ]
                }
            },
            "Resource": [
                "${var.destination_replica_kms_key_id}"
            ]
        }
    ]
}
POLICY
}