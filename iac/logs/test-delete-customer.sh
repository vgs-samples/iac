#/bin/bash

export ORGANIZATION_ID=orgasd123
export AWS_PROFILE=simulator
export AWS_REGION=us-east-1
export CUSTOMER_AWS_ACCOUNT_ID=767398127962
export VGS_AWS_ACCOUNT_ID=293664699268

aws cloudformation delete-stack --stack-name=customer-logs-from-vgs-for-$ORGANIZATION_ID