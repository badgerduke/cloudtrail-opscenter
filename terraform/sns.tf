resource "aws_sns_topic" "example_sns_topic" {
  name = var.sns_topic_name
}

resource "aws_sns_topic_subscription" "example_sns_subscription" {
  topic_arn = aws_sns_topic.example_sns_topic.arn
  protocol  = "email"
  endpoint  = var.sns_email
}

resource "aws_sns_topic_policy" "default" {
  arn    = aws_sns_topic.example_sns_topic.arn
  policy = data.aws_iam_policy_document.example_sns_topic_policy.json
}

data "aws_iam_policy_document" "example_sns_topic_policy" {
  statement {
    effect  = "Allow"
    actions = ["SNS:Publish"]
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
    resources = [aws_sns_topic.example_sns_topic.arn]
  }
}