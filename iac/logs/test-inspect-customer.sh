#/bin/bash

export ORGANIZATION_ID=$(echo ACoKRUTV7ETUsqWjMJGEWJZb | tr '[:upper:]' '[:lower:]')
export AWS_PROFILE=simulator
export AWS_REGION=us-east-1
export CUSTOMER_AWS_ACCOUNT_ID=767398127962
export VGS_AWS_ACCOUNT_ID=293664699268

aws cloudformation list-stacks | jq '.StackSummaries[] | select(.StackStatus != "DELETE_COMPLETE") | (.StackName, .StackStatus)'
aws cloudformation describe-stack-events --stack-name=customer-logs-from-vgs-for-$ORGANIZATION_ID