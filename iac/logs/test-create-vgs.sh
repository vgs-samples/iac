#/bin/bash

export ORGANIZATION_ID=orgasd123
export AWS_PROFILE=dev/logs/sso
export AWS_REGION=us-east-1
export CUSTOMER_AWS_ACCOUNT_ID=767398127962
export VGS_AWS_ACCOUNT_ID=293664699268


aws cloudformation create-stack \
 --stack-name customer-logs-from-vgs-for-$ORGANIZATION_ID \
 --template-body file://./iac/logs/002-vgs-source.yaml \
 --parameters ParameterKey=CustomerVgsOrganizationId,ParameterValue=$ORGANIZATION_ID ParameterKey=CustomerAwsAccountId,ParameterValue=$CUSTOMER_AWS_ACCOUNT_ID --capabilities CAPABILITY_NAMED_IAM
