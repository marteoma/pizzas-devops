# NGINX Service
resource "aws_ecs_service" "backend" {
  name            = var.cluster_service_name
  cluster         = aws_ecs_cluster.backend-cluster.id
  task_definition = aws_ecs_task_definition.backend.arn
  desired_count   = var.desired_tasks
  iam_role        = aws_iam_role.ecs-service-role.arn
  depends_on      = [aws_iam_role_policy_attachment.ecs-service-attach]

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
  execution_role_arn      = aws_iam_role.parameter-store-role.arn
  container_definitions = <<EOF
[
  {
    "portMappings": [
      {
        "hostPort": 0,
        "protocol": "tcp",
        "containerPort": 8080
      }
    ],
    "secrets": [
      {
          "name": "MYSQL_DB_DATABASE",
          "valueFrom": "arn:aws:ssm:us-east-1:427612221002:parameter/MYSQL_DB_DATABASE"
      },
      {
          "name": "MYSQL_DB_PASSWORD",
          "valueFrom": "arn:aws:ssm:us-east-1:427612221002:parameter/MYSQL_DB_PASSWORD"
      },
      {
          "name": "MYSQL_DB_PORT",
          "valueFrom": "arn:aws:ssm:us-east-1:427612221002:parameter/MYSQL_DB_PORT"
      },
      {
        "name": "MYSQL_DB_HOST",
        "valueFrom": "arn:aws:ssm:us-east-1:427612221002:parameter/MYSQL_DB_HOST"
      },
      {
          "name": "MYSQL_DB_USER",
          "valueFrom": "arn:aws:ssm:us-east-1:427612221002:parameter/MYSQL_DB_USER"
      }
    ],
    "memory": 300,
    "image": "marteoma/pizzas-back:latest",
    "essential": true,
    "name": "pizzasback",
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs-demo/backend",
        "awslogs-region": "us-east-1",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }
]
EOF
}

resource "aws_cloudwatch_log_group" "backend" {
  name = "/ecs-demo/backend"
}