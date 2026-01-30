############################################
# ALB MODULE
# Purpose:
# - Expose ECS backend service to the internet
# - Perform HTTP health checks on /health
# - Forward traffic to ECS EC2 instances
############################################

############################################
# SECURITY GROUP FOR ALB
############################################
resource "aws_security_group" "alb" {
  name        = "${var.project_name}-${var.environment}-alb-sg"
  description = "Allow HTTP traffic from the internet"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow inbound HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-alb-sg"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

############################################
# APPLICATION LOAD BALANCER
############################################
resource "aws_lb" "this" {
  name               = "${var.project_name}-${var.environment}-alb"
  load_balancer_type = "application"
  internal           = false

  security_groups = [aws_security_group.alb.id]
  subnets         = var.public_subnet_ids

  tags = {
    Name        = "${var.project_name}-${var.environment}-alb"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

############################################
# TARGET GROUP (ECS EC2 - INSTANCE MODE)
############################################
resource "aws_lb_target_group" "this" {
  name        = "${var.project_name}-${var.environment}-tg"
  port        = 5000
  protocol    = "HTTP"
  target_type = "instance" # REQUIRED for ECS EC2 + bridge mode
  vpc_id      = var.vpc_id

  health_check {
    path                = "/health"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-tg"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

############################################
# HTTP LISTENER
############################################
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}
