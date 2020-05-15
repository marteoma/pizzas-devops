output "alb_output" {
  value = aws_alb.alb-backend.dns_name
  description = "DNS of the ALB for accessing the backend"
}

output "db_output" {
  value = aws_db_instance.pizzas.address
  description = "Address to connect to the database"
}