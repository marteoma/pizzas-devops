# ECS cluster
resource "aws_ecs_cluster" "backend-cluster" {
  name = var.ecs_cluster_name
}
#Compute
resource "aws_autoscaling_group" "asg-cluster" {
  name                      = var.asg_name
  # vpc_zone_identifier       = [aws_subnet.public.id[count.index]]
  vpc_zone_identifier       = [
    for s in aws_subnet.public :
      s.id
  ]
  min_size                  = var.min_cluster_size
  max_size                  = var.max_cluster_size
  launch_configuration      = aws_launch_configuration.cluster-lc.name
  health_check_grace_period = 120
  termination_policies      = ["OldestInstance"]
}

resource "aws_autoscaling_policy" "asg-policy" {
  name                      = var.asg_policy_name
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = "90"
  adjustment_type           = "ChangeInCapacity"
  autoscaling_group_name    = aws_autoscaling_group.asg-cluster.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 40.0
  }
}

resource "aws_launch_configuration" "cluster-lc" {
  name_prefix     = "demo-cluster-lc"
  security_groups = [aws_security_group.instance_sg.id]

  key_name                    = var.key_name
  image_id                    = var.ami_id
  instance_type               = var.instance_type
  iam_instance_profile        = aws_iam_instance_profile.ecs-ec2-role.id
  user_data                   = data.template_file.ecs-cluster.rendered
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }
}