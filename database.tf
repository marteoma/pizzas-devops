resource "aws_db_subnet_group" "private_subnets" {
    name                    = var.rds_subnet_group_name
    subnet_ids              = [
    for s in aws_subnet.private :
      s.id
  ]
    tags                    = var.tags
}

resource "aws_db_instance" "pizzas" {
    identifier              = var.rds_database_identifier
    allocated_storage       = var.rds_allocated_storage
    storage_type            = var.rds_storage_type
    engine                  = var.rds_engine
    engine_version          = var.rds_engine_version
    instance_class          = var.rds_instance_class
    name                    = var.rds_database_name
    username                = var.rds_database_username
    password                = var.rds_database_password
    availability_zone       = local.availability_zones[0]
    vpc_security_group_ids  = [aws_security_group.db_sg.id]
    db_subnet_group_name    = aws_db_subnet_group.private_subnets.name
    skip_final_snapshot     = "true"

    tags                    = var.tags
}