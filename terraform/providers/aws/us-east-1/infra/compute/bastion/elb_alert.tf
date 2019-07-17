resource "aws_cloudwatch_metric_alarm" "bastion-ssh-elb-alert" {
  alarm_name          = "Bastion SSH ELB has unhealthy host"
  comparison_operator = "GreaterThanOrEqualToThreshold"

  period              = "60"
  evaluation_periods  = "1"
  datapoints_to_alarm = 1

  # second
  statistic         = "Maximum"
  threshold         = "1"
  alarm_description = ""

  metric_name = "UnHealthyHostCount"
  namespace   = "AWS/ELB"
  dimensions = {
    LoadBalancerName = module.bastion_elb.this_elb_name
  }

  actions_enabled           = true
  insufficient_data_actions = []
  ok_actions                = []
  alarm_actions             = [module.sns-email-topic.arn]
}

module "sns-email-topic" {
  source  = "github.com/koalificationio/tf-sns-email-list?ref=0.0.1"

  display_name    = "CloudWatch Bastion SSH ELB Alerts"
  email_addresses = local.alert_subscribers
  stack_name      = "bastion-ssh-alerts-sns-stack"
}
