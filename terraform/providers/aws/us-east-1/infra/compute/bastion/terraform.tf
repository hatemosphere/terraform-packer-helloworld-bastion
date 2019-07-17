terraform {
  required_version = "0.12.4"

  backend "s3" {
    bucket         = "xxx"
    key            = "terraform/state/us-east-1/infra/compute/bastion/terraform.tfstate"
    encrypt        = true
    kms_key_id     = "arn:aws:kms:eu-central-1:xxx:key/xxx"
    region         = "us-east-1"
    dynamodb_table = "xxx"
  }
}
