data "template_file" "ecs-cluster" {
  template = file("ecs-cluster.tpl")

  vars = {
    ecs_cluster = aws_ecs_cluster.backend-cluster.name
  }
}

data "template_file" "container_definition" {
  template = file("container-definition.json")
  vars = {
    host     = aws_db_instance.pizzas.address
    port     = aws_db_instance.pizzas.port
    user     = aws_db_instance.pizzas.username
    password = aws_db_instance.pizzas.password
    database = aws_db_instance.pizzas.name
  }
}