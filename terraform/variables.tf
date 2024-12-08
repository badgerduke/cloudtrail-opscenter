variable "custom_trail_name" {
 type = string
 description = "The name of the custom Cloudtrail trail"
}

variable "custom_trail_s3_prefix" {
 type = string
 description = "The S3 prefix in the bucket storing CloudTrail logs"
}

variable "custom_trail_S3_name" {
 type = string
 description = "The name of the S3 bucket storing the custom trail logs"
}

variable "security_group_name" {
 type = string
 description = "The name of the security group"
}

/*
variable "sns_topic_name" {
 type = string
 description = "The name of the SNS topic"
}

variable "sns_email" {
 type = string
 description = "The email address subscibing to the SNS topic"
}
*/
variable "eventbridge_rule_name" {
 type = string
 description = "The name of the Eventbridge rule listening for security group changes"
}