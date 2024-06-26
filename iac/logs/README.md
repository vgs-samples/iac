# Logs AWS S3 Bucket Replication Setup

Allows creating S3 buckets via Cloudformation for transferring logs (audit and access logs) from VGS to a customer's S3 bucket using S3 replication.

This has the benefit of pushing replication to AWS and avoiding having to configure replication via SFTP or other approaches.

Log replication requires a series of buckets to be created. This differs from MFT buckets in that logs are scoped to organizations and not vaults. Logs for many vaults may be placed in a single logs bucket adjacent to organization audit logs etc.

- **VGS Logs Bucket** - `vgs-logs-to-customer-orgasd123`
   Any file placed in this bucket will automatically be replicated to the Customer Destination Bucket.
- **Customer Destination Bucket** - `customer-logs-from-vgs-orgasd123`
   This bucket is provisioned in the customer's AWS account.

   Files processed by VGS and placed here once they are processed.

## Quickstart

```bash
export ORGANIZATION_ID=orgasd123  # TODO: This should be your organization ID
export CUSTOMER_AWS_ACCOUNT_ID=767398127962  # TODO: This should be your AWS account ID
export VGS_AWS_ACCOUNT_ID=582054058224
export AWS_REGION=us-west-2

aws cloudformation create-stack \
 --stack-name customer-logs-from-vgs-for-$ORGANIZATION_ID \
 --template-body file://./iac/logs/001-customer-receiver.yaml \
 --parameters ParameterKey=CustomerVgsOrganizationId,ParameterValue=$ORGANIZATION_ID ParameterKey=VgsAwsAccountId,ParameterValue=$VGS_AWS_ACCOUNT_ID --capabilities CAPABILITY_NAMED_IAM
```

Note - You must create the bucket to receive the files _before_ you create the bucket to replicate files. It's an AWS thing.
