locals {
  ssh_keypair_name = "dreamteam-infra"
  vpc_id           = data.terraform_remote_state.infra_vpc.outputs.vpc_id
  public_subnets   = data.terraform_remote_state.infra_vpc.outputs.public_subnets
  private_subnets  = data.terraform_remote_state.infra_vpc.outputs.private_subnets
}
