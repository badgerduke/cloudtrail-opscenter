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
 
resource "aws_cloudwatch_event_target" "opsitem" {
  rule      = aws_cloudwatch_event_rule.rule_for_sg_change.name
  target_id = "SendToOpsCenter"
  arn       = "arn:aws:ssm:us-east-1:093879445146:opsitem"
  role_arn  = aws_iam_role.opsitem_create.arn
  input_transformer {
    input_paths    = {
      "account": "$.account",
      "eventName": "$.detail.eventName",
      "eventTime": "$.detail.eventTime",
      "id": "$.detail.requestParameters.ModifySecurityGroupRulesRequest.GroupId",
      "region": "$.region",
      "source": "$.source",
      "username": "$.detail.userIdentity.userName"
    }
    input_template = <<TEMPLATE
      {
  "title": "SG modified",
  "description": "security_group_changes was triggered.",
  "category": "Security",
  "severity": "2",
  "source": "EC2",
  "operationalData": {
          "/aws/dedup": {
        "type": "SearchableString",
        "value": "{\"dedupString\":\"ModifySecurityGroupRules\"}"
    },
      "source": {
          "value": <source>
      },
      "username": {
          "value": <username>
      },
      "eventName": {
          "value": <eventName>
      },
      "eventTime": {
         "value": <eventTime>
      },
      "account": {
          "value": <account>
      },
      "region": {
         "value": <region>
      },
      "id": {
         "value": <id> 
      }  
  }
}
    TEMPLATE  
  }
}


resource "aws_cloudwatch_event_rule" "rule_for_opsitem_create" {
  name          = "opsItem_create_event"

  event_pattern = <<EOF
  {
    "source": ["aws.ssm"],
    "detail-type": ["OpsItem Create"],
    "detail": {
      "status": ["Open"],
      "title": ["SG modified"]
    }
  }
  EOF
}  

resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.rule_for_opsitem_create.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.example_sns_topic.arn
}


resource "aws_iam_role" "opsitem_create" {

  name               = "demo-opsitem-create-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "events.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "create_ops_role_policy_attach" {
  role       = "${aws_iam_role.opsitem_create.name}"
  policy_arn = "${aws_iam_policy.create_opsitem_policy.arn}"
}

resource "aws_iam_policy" "create_opsitem_policy" {
  name        = "demo-create-opsitem-policy"
  policy      = jsonencode({
      
        "Version": "2012-10-17",
        "Statement": [
          {
            "Effect": "Allow",
            "Action": [
                "ssm:CreateOpsItem",
                "ssm:AddTagsToResource"
            ],
            "Resource": [
                "arn:aws:ssm:*:*:opsitem/*"
            ]
          }
        ]
      
  })
}
