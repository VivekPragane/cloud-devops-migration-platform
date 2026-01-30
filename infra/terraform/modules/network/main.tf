############################################
# NETWORK MODULE
# Purpose:
# - Create a minimal, cost-aware AWS network
# - Optimized for ECS (EC2 launch type) + ALB
# - Public-only design (no NAT Gateway) by intent
############################################

#-------------------------------------------
# VPC
#-------------------------------------------
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr

  # Required for ALB, ECS service discovery, and DNS resolution
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-vpc"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

#-------------------------------------------
# Internet Gateway
# Enables outbound internet access for public subnets
#-------------------------------------------
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "${var.project_name}-${var.environment}-igw"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

#-------------------------------------------
# Public Subnets
# - One subnet per AZ
# - Public IPs assigned on launch
# - ECS EC2 instances + ALB will live here
#-------------------------------------------
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-public-${var.availability_zones[count.index]}"
    Project     = var.project_name
    Environment = var.environment
    Tier        = "public"
    ManagedBy   = "terraform"
  }
}

#--------------------------------------------
# Public Route Table
# Routes all outbound traffic to Internet Gateway
#--------------------------------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-public-rt"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

#--------------------------------------------
# Route Table Associations
# Attach public route table to each public subnet
#--------------------------------------------
resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
