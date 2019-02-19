variable "bucket_name" {}
variable "log_bucket_name" {}

variable "region" {
  description = "Region of the bucket data"
}

variable "prefix" {
  default     = "/"
  description = "Object keyname prefix identifying one or more objects to which the rule applies"
}

variable "lifecycle_glacier_transition_days" {
  description = "The number of days after object creation when the object is archived into Glacier (access logs)."
  default     = 90
}

variable "enable_expiration" {
  description = "Set to true to enable object expiration"
  default     = false
}

variable "expiration" {
  description = "Specifies a period in the object's expire (days)"
  default     = 365
}

variable "transition" {
  description = "Specifies a period in the object's transitions (days)"
  default     = 90
}

variable "noncurrent_version_expiration" {
  description = "Specifies when noncurrent object versions expire (days)"
  default     = 365
}

variable "noncurrent_version_transition" {
  description = "Specifies when noncurrent object versions transitions (days)"
  default     = 90
}

variable "transition_storage_class" {
  default     = "GLACIER"
  description = "Specifies the Amazon S3 storage class to which you want the object to transition. Can be ONEZONE_IA, STANDARD_IA, INTELLIGENT_TIERING, or GLACIER"
}

variable "noncurrent_version_transition_storage_class" {
  default     = "GLACIER"
  description = "Specifies the Amazon S3 storage class to which you want the noncurrent versions object to transition. Can be ONEZONE_IA, STANDARD_IA, INTELLIGENT_TIERING, or GLACIER"
}

variable "replication_status" {
  default     = "Disabled"
  description = "The status of the rule. Either Enabled or Disabled. The rule is ignored if status is not Enabled"
}

variable "replication_prefix" {
  description = "Object keyname prefix identifying one or more objects to which the rule applies"
  default     = "/"
}

variable "config_destination_bucket_arn" {
  description = "The ARN of the S3 bucket where you want Amazon S3 to store replicas of the config object identified by the rule"
}

variable "cloudtrail_destination_bucket_arn" {
  description = "The ARN of the S3 bucket where you want Amazon S3 to store replicas of the cloudtrail object identified by the rule"
}

variable "source_kms_key_id" {
  description = "AWS KMS key IDs used to encrypt source objects"
}

variable "destination_replica_kms_key_id" {
  description = "Destination KMS encryption key ARN for SSE-KMS replication. Must be used in conjunction with sse_kms_encrypted_objects source selection criteria"
}

variable "destination_region" {
  description = "Destination region of the bucket data"
  default     = "us-east-2"
}

variable "aws_account_id" {
  description = "The AWS Account ID number of the account."
}
