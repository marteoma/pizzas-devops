variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "us-east-1"
}

variable "instance_type" {
  default     = "t2.micro"
  description = "AWS instance type"
}

# ECS
variable "ecs_cluster_name" {
  type    = string
  default = "backend-pizzas-cluster"
}

variable "asg_name" {
    type  = string
    default =  "asg-backend"
}

variable "min_cluster_size" {
    description     = "Minimum size of the cluster"
    default         = "2"
}

variable "max_cluster_size" {
    description     = "Maximum size of the cluster"
    default         = "3"
}

variable "desired_tasks" {
    description     = "Desired number of tasks running"
    default         = "2"
}

variable "asg_policy_name" {
    type = string
    default = "asg-policy"
}

variable "key_name" {
    description = "Name of the key pair to access the instances"
    default     = "marboleda-key-pair"
}

variable "ami_id" {
    description = "AMI to use in the instances"
    default     = "ami-0aee8ced190c05726"
}

variable "cluster_service_name" {
    default = "pizzasback"
}

variable "cluster_task_name" {
    default = "pizzasback"
}

variable "container_name" {
    default = "pizzasback"
}

# Networking

variable "vpc_name" {
  type    = string
  default = "pizzas-rampup-vpc"
}

variable "cidr_block" {
    type    = string
    default = "172.20.0.0/16"
}

variable "cidr_ab" {
    type    = string
    default = "172.20"
}

variable "backend_sg_name" {
    description     = "Backend Security Group Name"
    default         = "backend_sg"
}

variable "backend_sg_description" {
    description     = "Backend Security Group Description"
    default         = "Allow incoming HTTP connections"
}

variable "alb_sg_name" {
    description     = "ALB Security Group Name"
    default         = "alb_sg"
}

variable "alb_sg_description" {
    description     = "ALB Security Group Description"
    default         = "Terraform ALB Security Group"
}

variable "db_sg_name" {
    description     = "DB Security Group Name"
    default         = "db_sg"
}

variable "db_sg_description" {
    description     = "DB Security Group Description"
    default         = "Allow incoming database connections from public web servers"
}


# Number of EC2 Instances
variable "number_of_instances" {
    description     = "Number of instances"
    default         = 2 
}

/* RDS Configuration Init */

variable "rds_database_identifier" {
    description     = "RDS Database Identifier"
    default         = "pizzasdb"
}

variable "rds_instance_class" {
    description     = "RDS Instance Class"
    default         = "db.t2.micro"
}

variable "rds_database_name" {
    description     = "RDS Database Name"
    default         = "pizzasdb"
}

variable "rds_database_username" {
    description     = "RDS Database Username"
    default         = "root"
}

# Bad practice: create a secret
variable "rds_database_password" {
    description     = "RDS Database Password"
}

variable "rds_subnet_group_name" {
    description     = "RDS Subnet Group Name"
    default         = "db_private_subnet"
}

variable "rds_allocated_storage" {
    description     = "RDS Storage to Allocate"
    default         = 8
}

variable "rds_storage_type" {
    description     = "RDS Storage Type"
    default         = "gp2"
}

variable "rds_engine" {
    description     = "RDS Engine"
    default         = "mysql"
}

variable "rds_engine_version" {
    description     = "RDS Engine Version"
    default         = "8.0"
}

# Load balancer

variable "alb_name" {
    description     = "ALB Name"
    default         = "alb-pizzas"
}

variable "tags" {
  type          = map(string)
  description   = "Tags for all the resources created with terraform"
  default       = {
    "owner":"marboleda", 
    "project":"Pizzas RampUp", 
    "provisioner":"Terraform"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
    availability_zones        = data.aws_availability_zones.available.names
    cidr_c_private_subnets    = 1
    cidr_c_public_subnets     = 64
}