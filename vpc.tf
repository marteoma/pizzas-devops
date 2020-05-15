resource "aws_vpc" "pizzas" {
  cidr_block           = var.cidr_block
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"

  tags = var.tags
}

# Subnets
# resource "aws_subnet" "demo-public-1" {
#   vpc_id                  = aws_vpc.pizzas.id
#   cidr_block              = var.cidr_block
#   map_public_ip_on_launch = "true"
#   availability_zone       = "us-east-1a"

#   tags = var.tags
# }

# resource "aws_subnet" "demo-public-2" {
#   vpc_id                  = aws_vpc.pizzas.id
#   cidr_block              = "172.21.20.0/24"
#   map_public_ip_on_launch = "true"
#   availability_zone       = "us-east-1b"

#   tags = var.tags
# }

# resource "aws_subnet" "demo-public-3" {
#   vpc_id                  = aws_vpc.pizzas.id
#   cidr_block              = "172.21.30.0/24"
#   map_public_ip_on_launch = "true"
#   availability_zone       = "us-east-1c"

#   tags = var.tags
# }

resource "aws_subnet" "public" {
  count                   = length(local.availability_zones)
  vpc_id                  = aws_vpc.pizzas.id
  # cidr_block              = cidrsubnet(var.cidr_block, 8, count.index + local.cidr_c_public_subnets)
  cidr_block              = "${var.cidr_ab}.${local.cidr_c_public_subnets + count.index}.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = element(local.availability_zones, count.index)

  tags = var.tags
}

resource "aws_subnet" "private" {
  count                   = length(local.availability_zones)
  vpc_id                  = aws_vpc.pizzas.id
  cidr_block              = "${var.cidr_ab}.${local.cidr_c_private_subnets + count.index}.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = element(local.availability_zones, count.index)

  tags = var.tags
}

# Internet GW
resource "aws_internet_gateway" "demo-gw" {
  vpc_id = aws_vpc.pizzas.id
  tags = var.tags
}

# route tables
resource "aws_route_table" "public_igw" {
  vpc_id = aws_vpc.pizzas.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo-gw.id
  }

  tags = var.tags
}

resource "aws_route_table_association" "public_igw" {
  count          = length(local.availability_zones)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public_igw.id
}

