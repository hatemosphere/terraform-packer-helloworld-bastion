data "aws_ami" "bastion_ubuntu" {
  most_recent = true
  owners      = ["self"]

  filter {
    name = "name"

    values = [
      "ubuntu-18.04-ssh-bastion-*",
    ]
  }
}
