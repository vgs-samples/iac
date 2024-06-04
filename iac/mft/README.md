# MFT AWS S3 Bucket Replication Setup

Allows creating S3 buckets via Cloudformation for transferring files from a remote source to VGS using AWS S3 bucket replication.

This has the benefit of pushing replication to AWS and avoiding having to configure replication via SFTP or other approaches.

MFT replication requires a series of buckets to be created.

- **Customer Source Bucket** (CSB) - `customer-files-to-vgs-tntasd123` - buckets are consistently named and always suffixed with the customer's vault ID.
   This bucket is provisioned in the customer's AWS account.

   When they place a file here it is replicated to the VGS source bucket.
- **VGS Source Bucket** (VSB) - `vgs-files-from-customer-tntasd123`
   This bucket is a fascade for the MFT processing stack.

   We may destroy and re-create MFT processing stacks whereas this bucket will stay static which is important since it's referenced in the customer's infrastructure.
- **Internal Source Bucket** (ISB) - TBD.
   When a file is placed in this bucket the MFT stack will scan for it, find it and begin processing.

   This bucket is provisioned and managed by the MFT stack.
- **Internal Destination Bucket** (IDB) - TBD
   Once files are processed by the MFT stack they are placed in this folder for delivery.

   This bucket is provisioned and managed by the MFT stack.
- **VGS Destination Bucket** (VDB) - `vgs-files-to-customer-tntasd123`
   This bucket is a fascade for the MFT processing stack.

   We may destroy and re-create MFT processing stacks whereas this bucket will stay static which is important since it's referenced in the customer's infrastructure.

   Any file placed in this bucket will automatically be replicated to the Customer Destination Bucket.
- **Customer Destination Bucket** (CDB) - `customer-files-from-vgs-tntasd123`
   This bucket is provisioned in the customer's AWS account.

   Files processed by VGS and placed here once they are processed.

The flow of files is CSB -> VSB -> ISB -> IDB -> VDB -> CDB.

## TODOs

- Add environment specific prefixes to buckets
- Add automated testing, this is complex.
- Add S3 encryption
- Implement sending files from VGS
- SNS notifications for replication events
- SFTP receiving and delivering
    - https://aws.amazon.com/aws-transfer-family/ can be used to receive files into the VSB

## Quickstart

Set some environment variables

```bash
# these are test values, replace with real ones
export VAULT_ID=tntasd123
export CUSTOMER_AWS_ACCOUNT_ID=767398127962
export VGS_AWS_ACCOUNT_ID=767398127962
export AWS_REGION=us-west-2
export AWS_PROFILE=simulator
```

Note - You must create the bucket to receive the files _before_ you create the bucket to replicate files. It's an AWS thing.

### Receiving Files from Customer

#### VGS AWS Account

Create an S3 bucket to receive files for a customer.

```bash
 aws cloudformation create-stack \
 --stack-name vgs-receiver-stack-$VAULT_ID \
 --template-body file://./iac/mft/001-vgs-receiver.yaml \
 --parameters ParameterKey=CustomerVgsVaultId,ParameterValue=$VAULT_ID ParameterKey=CustomerAwsAccountId,ParameterValue=$CUSTOMER_AWS_ACCOUNT_ID --capabilities CAPABILITY_NAMED_IAM
```

#### Sending AWS Account

Create an S3 bucket in the sending parties AWS account that will ship files to VGS

```bash
aws cloudformation create-stack \
 --stack-name customer-sending-stack-$VAULT_ID \
 --template-body file://./iac/mft/002-customer-source.yaml \
 --parameters ParameterKey=CustomerVgsVaultId,ParameterValue=$VAULT_ID ParameterKey=VgsAwsAccountId,ParameterValue=$VGS_AWS_ACCOUNT_ID --capabilities CAPABILITY_NAMED_IAM
```

### Sending Files to Customer

### Customer Account

Create an S3 bucket to receive files from VGS

```bash
aws cloudformation create-stack \
 --stack-name customer-files-from-vgs-for-$VAULT_ID \
 --template-body file://./iac/mft/003-customer-receiver.yaml \
 --parameters ParameterKey=CustomerVgsVaultId,ParameterValue=$VAULT_ID ParameterKey=VgsAwsAccountId,ParameterValue=$VGS_AWS_ACCOUNT_ID --capabilities CAPABILITY_NAMED_IAM
```

#### VGS AWS Account

Create an S3 bucket to send files to a customer

```bash
aws cloudformation create-stack \
 --stack-name vgs-sending-stack-$VAULT_ID \
 --template-body file://./iac/mft/004-vgs-source.yaml \
 --parameters ParameterKey=CustomerVgsVaultId,ParameterValue=$VAULT_ID ParameterKey=CustomerAwsAccountId,ParameterValue=$CUSTOMER_AWS_ACCOUNT_ID --capabilities CAPABILITY_NAMED_IAM
```


## Connecting buckes to internal MFT buckets