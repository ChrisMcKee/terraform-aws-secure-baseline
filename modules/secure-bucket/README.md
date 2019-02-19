# secure-bucket

Creates a S3 bucket with access logging enabled.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws\_account\_id | The AWS Account ID number of the account. | string | n/a | yes |
| bucket\_name |  | string | n/a | yes |
| cloudtrail\_destination\_bucket\_arn | The ARN of the S3 bucket where you want Amazon S3 to store replicas of the cloudtrail object identified by the rule | string | n/a | yes |
| config\_destination\_bucket\_arn | The ARN of the S3 bucket where you want Amazon S3 to store replicas of the config object identified by the rule | string | n/a | yes |
| destination\_replica\_kms\_key\_id | Destination KMS encryption key ARN for SSE-KMS replication. Must be used in conjunction with sse_kms_encrypted_objects source selection criteria | string | n/a | yes |
| log\_bucket\_name |  | string | n/a | yes |
| region | Region of the bucket data | string | n/a | yes |
| source\_kms\_key\_id | AWS KMS key IDs used to encrypt source objects | string | n/a | yes |
| destination\_region | Destination region of the bucket data | string | `"us-east-2"` | no |
| enable\_expiration | Set to true to enable object expiration | string | `"false"` | no |
| expiration | Specifies a period in the object's expire (days) | string | `"365"` | no |
| lifecycle\_glacier\_transition\_days | The number of days after object creation when the object is archived into Glacier (access logs). | string | `"90"` | no |
| noncurrent\_version\_expiration | Specifies when noncurrent object versions expire (days) | string | `"365"` | no |
| noncurrent\_version\_transition | Specifies when noncurrent object versions transitions (days) | string | `"90"` | no |
| noncurrent\_version\_transition\_storage\_class | Specifies the Amazon S3 storage class to which you want the noncurrent versions object to transition. Can be ONEZONE_IA, STANDARD_IA, INTELLIGENT_TIERING, or GLACIER | string | `"GLACIER"` | no |
| prefix | Object keyname prefix identifying one or more objects to which the rule applies | string | `"/"` | no |
| replication\_prefix | Object keyname prefix identifying one or more objects to which the rule applies | string | `"/"` | no |
| replication\_status | The status of the rule. Either Enabled or Disabled. The rule is ignored if status is not Enabled | string | `"Disabled"` | no |
| transition | Specifies a period in the object's transitions (days) | string | `"90"` | no |
| transition\_storage\_class | Specifies the Amazon S3 storage class to which you want the object to transition. Can be ONEZONE_IA, STANDARD_IA, INTELLIGENT_TIERING, or GLACIER | string | `"GLACIER"` | no |

## Outputs

| Name | Description |
|------|-------------|
| log\_bucket\_arn | The ARN of the S3 bucket used for storing access logs of this bucket. |
| log\_bucket\_id | The ID of the S3 bucket used for storing access logs of this bucket. |
| this\_bucket\_arn | The ARN of this S3 bucket. |
| this\_bucket\_id | The ID of this S3 bucket. |

