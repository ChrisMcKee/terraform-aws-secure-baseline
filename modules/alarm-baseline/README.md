# alarm-baseline

Set up CloudWatch alarms to notify you when critical changes happen in your AWS account.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| cloudtrail\_log\_group\_name | The name of the CloudWatch Logs group to which CloudTrail events are delivered. | string | n/a | yes |
| alarm\_namespace | The namespace in which all alarms are set up. | string | `"CISBenchmark"` | no |
| sns\_topic\_name | The name of the SNS Topic which will be notified when any alarm is performed. | string | `"CISAlarm"` | no |

## Outputs

| Name | Description |
|------|-------------|
| alarm\_topic\_arn | The ARN of the SNS topic to which CloudWatch Alarms will be sent. |
| alarm\_topic\_name | The name of the SNS Topic which will be notified when any alarm is performed |

