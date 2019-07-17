module "bastion_asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "3.0.0"

  name = "bastion-asg"

  lc_name = "bastion-ssh-lc"

  image_id        = data.aws_ami.bastion_ubuntu.id
  instance_type   = "t3.micro"
  key_name        = local.ssh_keypair_name
  security_groups = [aws_security_group.bastion_asg_ssh_sg.id]
  load_balancers  = [module.bastion_elb.this_elb_id]

  ebs_block_device = [
    {
      device_name           = "/dev/xvdz"
      volume_type           = "gp2"
      volume_size           = "50"
      delete_on_termination = true
    },
  ]

  root_block_device = [
    {
      volume_size = "50"
      volume_type = "gp2"
    },
  ]

  # Auto scaling group
  asg_name                  = "bastion-asg"
  vpc_zone_identifier       = local.private_subnets
  health_check_type         = "EC2"
  min_size                  = 1
  max_size                  = 1
  desired_capacity          = 1
  wait_for_capacity_timeout = 0

  tags = [
    {
      key                 = "Environment"
      value               = "infra"
      propagate_at_launch = true
    },
    {
      key                 = "Name"
      value               = "bastion-asg"
      propagate_at_launch = true
    },
  ]
}

module "bastion_elb" {
  source  = "terraform-aws-modules/elb/aws"
  version = "2.1.0"

  name = "bastion-elb"

  subnets         = local.public_subnets
  security_groups = [aws_security_group.bastion_elb_ssh_sg.id]
  internal        = false

  listener = [
    {
      instance_port     = "22"
      instance_protocol = "TCP"
      lb_port           = "22"
      lb_protocol       = "TCP"
    },
  ]

  health_check = {
    target              = "TCP:22"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
  }

  tags = {
    Name        = "bastion-elb"
    Environment = "infra"
  }
}

resource "aws_security_group" "bastion_asg_ssh_sg" {
  name        = "bastion-asg-ssh-from-elb"
  description = "Security group with TCP port open for access from ELB attached to ASG"
  vpc_id      = local.vpc_id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_elb_ssh_sg.id]
    self            = false
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "bastion-elb-ssh-sg"
    Environment = "infra"
  }
}

resource "aws_security_group" "bastion_elb_ssh_sg" {
  name        = "bastion-elb-ssh-external"
  description = "Security group with TCP port 22 open for world"
  vpc_id      = local.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "bastion-elb-ssh-sg"
    Environment = "infra"
  }
}
