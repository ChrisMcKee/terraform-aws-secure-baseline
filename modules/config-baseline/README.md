# config-baseline

Enable AWS Config in all regions to automatically take configuration snapshots.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| iam\_role\_arn | The ARN of the IAM Role which AWS Config will use. | string | n/a | yes |
| s3\_bucket\_name | The name of the S3 bucket which will store configuration snapshots. | string | n/a | yes |
| delivery\_channel\_name | The name of the delivery channel. | string | `"default"` | no |
| delivery\_frequency | The frequency which AWS Config sends a snapshot into the S3 bucket. | string | `"One_Hour"` | no |
| recorder\_name | The name of the configuration recorder. | string | `"default"` | no |
| s3\_key\_prefix | The prefix for the specified S3 bucket. | string | `""` | no |
| sns\_topic\_name | The name of the SNS Topic to be used to notify configuration changes. | string | `"ConfigChanges"` | no |

## Outputs

| Name | Description |
|------|-------------|
| config\_topic\_arn | The ARN of the SNS topic that AWS Config delivers notifications to. |
| config\_topic\_name | The name of the SNS topic that AWS Config delivers notifications to. |
| configuration\_recorder\_id | The name of the configuration recorder. |

