#/bin/bash

export ORGANIZATION_ID=$(echo ACoKRUTV7ETUsqWjMJGEWJZb | tr '[:upper:]' '[:lower:]')
export AWS_PROFILE=dev/logs/sso
export AWS_REGION=us-east-1
export CUSTOMER_AWS_ACCOUNT_ID=767398127962
export VGS_AWS_ACCOUNT_ID=293664699268

# aws s3api delete-objects --bucket=customer-logs-from-vgs-for-$ORGANIZATION_ID --delete="$(aws s3api list-object-versions --bucket=customer-logs-from-vgs-for-$ORGANIZATION_ID | jq '{Objects: [.Versions[] | {Key:.Key, VersionId : .VersionId}], Quiet: false}')"

aws cloudformation delete-stack --stack-name=customer-logs-from-vgs-for-$ORGANIZATION_ID