# terraform-packer-helloworld-bastion

## Ansible role local test guide

Install all the required tools to run tests:

Runtimes:

- JDK
- Ruby
- Python

Tools:

- VirtualBox
- Vagrant
- Ansible
- test-kitchen

---

Install test-kitchen dependencies:

```bash
vagrant plugin install vagrant-scp
gem install test-kitchen --no-document
gem install kitchen-ansible --no-document
gem install kitchen-vagrant --no-document
```

---

Boostrap virtual machine with Ansible role:

```bash
# Main test-kitchen commands:
kitchen converge # Bootstrap VM with role
kitchen login # SSH to to VM
kitchen destroy # Destroy VM
```

## AMI build guide

- Install Packer for your platform: <https://www.packer.io/intro/getting-started/install.html>
- Install goss provisioner for Packer <https://github.com/YaleUniversity/packer-provisioner-goss/#installation>

---

Export all environment variables required to build AMI on EC instance, such as:

```bash
PACKER_AWS_REGION
PACKER_AWS_VPC_ID
PACKER_AWS_SUBNET_ID
PACKER_AWS_SECURITY_GROUP_ID
PACKER_AWS_INSTANCE_TYPE
```

AMI meant to be built in private subnet without exposing public IP address, so connectivity to private IP is required here.

---

Inject AWS credentials with permissions to run EC2 and push the AMI in any convenient way supported by Golang SDK: <https://docs.aws.amazon.com/sdk-for-go/v1/developer-guide/configuring-sdk.html#specifying-credentials>

---

Run AMI build script and wait for completion:

```bash
cd packer && ./build.sh ec2ami
```

## Terraform provision guide

### Disclaimer

This assumes that underlying infrastructure is ready to run fully-fledged TF setup that consists of:

- S3 bucket to store remote TF state
- DynamoDB database for TF state lock
- KMS key for TF state enctyption
- VPC with public and private subnet(s) to deploy ELB and ASG, NAT gateway(s) to route external traffic from private subnet(s).

All related resources are replaced with `xxx` in Bastion TF configuration, so to run the setup you need to provide those values for proper resource names(IDs)

And yes, there is not fancy `user interface` provided, everything is in one configuration, there's no local values to change the most important settings without browsing trough spaghetti code. Ideally everything should be compiled into module if the case is  to deploy multiple cofigurations like this. Code for SSH key generation is missing, ideally all the SSH keys should be generated somewhere else and pushed to secure storage like SSM Parameter Store secret values, AWS Secrets Manager or something like Hashicorp Vault.

---

Install Terraform *0.12.4* or use tfenv/tfswitch

---

Browse to Terraform configuration directory:

```bash
cd terraform/providers/aws/us-east-1/infra/compute/bastion
```

---

Supply values for S3 bucket, DynamoDB table and KMS key. Pass VPC ID, private and bublic subnet IDs, SSH keypair name to `locals.tf`

---

Inject AWS credentials with permissions to run Terraform in any convenient way supported by Golang SDK: <https://docs.aws.amazon.com/sdk-for-go/v1/developer-guide/configuring-sdk.html#specifying-credentials>

---

Apply that darn thing at last:

```bash
teraform init
terraform plan
terraform apply
```

