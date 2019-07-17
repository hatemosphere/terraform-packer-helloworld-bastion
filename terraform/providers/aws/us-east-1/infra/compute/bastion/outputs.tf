# Launch configuration
output "bastion_launch_configuration_id" {
  description = "The ID of Bastion launch configuration"
  value       = module.bastion_asg.this_launch_configuration_id
}

# Autoscaling group
output "bastion_autoscaling_group_id" {
  description = "Bastion autoscaling group id"
  value       = module.bastion_asg.this_autoscaling_group_id
}

# ELB DNS name
output "bastion_elb_dns_name" {
  description = "DNS Name of the Bastion ELB"
  value       = module.bastion_elb.this_elb_dns_name
}
