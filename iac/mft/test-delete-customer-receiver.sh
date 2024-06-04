#/bin/bash

export VAULT_ID=tntspti5gpm
export AWS_PROFILE=simulator
export AWS_REGION=us-east-1
export CUSTOMER_AWS_ACCOUNT_ID=767398127962  # simulator
export VGS_AWS_ACCOUNT_ID=526682027428

aws cloudformation delete-stack --stack-name=customer-files-from-vgs-for-$VAULT_ID