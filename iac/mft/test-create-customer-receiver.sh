#/bin/bash

export VAULT_ID=tntspti5gpm
export AWS_PROFILE=simulator
export AWS_REGION=us-east-1
export CUSTOMER_AWS_ACCOUNT_ID=767398127962  # simulator
export VGS_AWS_ACCOUNT_ID=526682027428


aws cloudformation create-stack \
 --stack-name customer-files-from-vgs-for-$VAULT_ID \
 --template-body file://./iac/mft/003-customer-receiver.yaml \
 --parameters ParameterKey=CustomerVgsVaultId,ParameterValue=$VAULT_ID ParameterKey=VgsAwsAccountId,ParameterValue=$VGS_AWS_ACCOUNT_ID --capabilities CAPABILITY_NAMED_IAM
