# NGINX Service
resource "aws_ecs_service" "backend" {
  name            = var.cluster_service_name
  cluster         = aws_ecs_cluster.backend-cluster.id
  task_definition = aws_ecs_task_definition.backend.arn
  desired_count   = var.desired_tasks
  iam_role        = aws_iam_role.ecs-service-role.arn
  depends_on      = [aws_iam_role_policy_attachment.ecs-service-attach]
  deployment_minimum_healthy_percent = 30
  load_balancer {
    target_group_arn = aws_alb_target_group.backend.id
    container_name   = var.container_name
    container_port   = "8080"
  }

  lifecycle {
    ignore_changes = [task_definition]
  }
}

resource "aws_ecs_task_definition" "backend" {
  family = var.cluster_task_name
  depends_on      = [aws_db_instance.pizzas]
  execution_role_arn      = aws_iam_role.parameter-store-role.arn
  container_definitions   = data.template_file.container_definition.rendered
}

resource "aws_cloudwatch_log_group" "backend" {
  name = "/ecs-demo/backend"
}