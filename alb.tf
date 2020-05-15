resource "aws_alb" "alb-backend" {
  name            = var.alb_name
  subnets         = [
    for s in aws_subnet.public :
      s.id
  ]
  security_groups = [aws_security_group.lb_sg.id]
  enable_http2    = "true"
  idle_timeout    = 600
}

resource "aws_alb_listener" "alb-listener" {
  load_balancer_arn = aws_alb.alb-backend.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.backend.id
    type             = "forward"
  }
}

resource "aws_alb_target_group" "backend" {
  name       = "backend"
  port       = 80
  protocol   = "HTTP"
  vpc_id     = aws_vpc.pizzas.id
  depends_on = [aws_alb.alb-backend]

  health_check {
    path                = "/hello"
    healthy_threshold   = 2
    unhealthy_threshold = 4
    timeout             = 30
    interval            = 60
    matcher             = "200,201,202,301,302"
  }
}