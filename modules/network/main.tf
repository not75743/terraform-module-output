## VPC

resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"
  tags = {
    Name = "test_vpc"
  }
}

## Subnet

resource "aws_subnet" "public1" {
  availability_zone       = var.az_public1
  cidr_block              = var.cidr_public1
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = false
  tags = {
    Name = "test_public1"
  }
}

## InternetGateway

resource "aws_internet_gateway" "igw" {
  tags = {
    Name = "test_igw"
  }
  vpc_id = aws_vpc.vpc.id
}

## Public Route

resource "aws_route_table" "rtb-public" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "test_rtb-public"
  }
}

resource "aws_route" "public-route" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
  route_table_id         = aws_route_table.rtb-public.id
}

resource "aws_route_table_association" "pubsub1_routeassociation" {
  route_table_id = aws_route_table.rtb-public.id
  subnet_id      = aws_subnet.public1.id
}
