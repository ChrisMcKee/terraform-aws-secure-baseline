output "alarm_topic_arn" {
  description = "The ARN of the SNS topic to which CloudWatch Alarms will be sent."
  value       = "${aws_sns_topic.alarms.arn}"
}

output "alarm_topic_name" {
  description = "The name of the SNS Topic which will be notified when any alarm is performed"
  value = "${var.sns_topic_name}"
}
