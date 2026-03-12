resource "aws_autoscaling_group" "app_asg" {
  desired_capacity = 1
  max_size         = 3
  min_size         = 1

  vpc_zone_identifier = [ var.public_subnet ]

  target_group_arns = [
    var.app_tg
  ]

  launch_template {
    id      = var.app_lt
    version = "$Latest"
  }
}

resource "aws_autoscaling_policy" "cpu_policy" {
  name                   = "cpu-scale"
  autoscaling_group_name = aws_autoscaling_group.app_asg.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 50
  }
}
