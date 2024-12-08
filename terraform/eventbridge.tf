resource "aws_cloudwatch_event_rule" "rule_for_sg_change" {
  name          = var.eventbridge_rule_name

  event_pattern = <<EOF
    {
      "source": [
        "aws.ec2"
      ],
      "detail-type": [
        "AWS API Call via CloudTrail"
      ],
      "detail": {
        "eventSource": [
          "ec2.amazonaws.com"
        ],
        "eventName": [
          "ModifySecurityGroupRules"
        ]
      }
    }
  EOF
}  
 /*
resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.rule_for_sg_change.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.example_sns_topic.arn
}
*/