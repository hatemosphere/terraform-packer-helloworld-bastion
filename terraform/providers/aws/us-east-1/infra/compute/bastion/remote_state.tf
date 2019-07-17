data "terraform_remote_state" "infra_vpc" {
  backend = "s3"

  config = {
    bucket         = "xxx"
    key            = "terraform/state/us-east-1/infra/networking/vpc/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "xxx"
  }
}
