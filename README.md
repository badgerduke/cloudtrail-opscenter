# cloudtrial-opscenter

This repo sets up Amazon EventBridge to react to a modification of a Security Group by creating an Systems Manager OpsCenter OpsItem.  The first EventBridge reacts to the event in CloudTrail and creates an OpsItem.  The second EventBridge rule reacts to the creation of the OpsItem and triggers SNS to deliver a notification to the given email.

Upon receiving the message, a person can check the OpsItem for details.  The first EventBridge can be altered to provide specific details of the change.  As configured, this repo only reports the id of the Security Group.

