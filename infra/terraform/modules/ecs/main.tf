############################################
# ECS MODULE
# Purpose:
# - Run backend service on ECS (EC2 launch type)
# - Cost-aware, single-node cluster
# - ALB-integrated, CI/CD-ready
############################################

############################################
# ECS CLUSTER
############################################
resource "aws_ecs_cluster" "this" {
  name = "${var.project_name}-${var.environment}-cluster"

  # Enables detailed CloudWatch metrics (good for observability)
  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-cluster"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

############################################
# IAM ROLE FOR ECS EC2 INSTANCES
############################################
resource "aws_iam_role" "ecs_instance_role" {
  name = "${var.project_name}-${var.environment}-ecs-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role_policy" {
  role       = aws_iam_role.ecs_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs" {
  name = "${var.project_name}-${var.environment}-ecs-instance-profile"
  role = aws_iam_role.ecs_instance_role.name
}

############################################
# SECURITY GROUP FOR ECS INSTANCES
# - Allows traffic ONLY from ALB on app port
############################################
resource "aws_security_group" "ecs_instances" {
  name   = "${var.project_name}-${var.environment}-ecs-sg"
  vpc_id = var.vpc_id

  ingress {
    description     = "Allow ALB to reach ECS tasks"
    from_port       = 5000
    to_port         = 5000
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-ecs-sg"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

############################################
# ECS-OPTIMIZED AMAZON LINUX 2 AMI
############################################
data "aws_ami" "ecs" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}

############################################
# LAUNCH TEMPLATE FOR ECS NODES
############################################
resource "aws_launch_template" "ecs" {
  name_prefix   = "${var.project_name}-${var.environment}-ecs-"
  image_id      = data.aws_ami.ecs.id
  instance_type = "t3.micro"

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs.name
  }

  user_data = base64encode(<<EOF
#!/bin/bash
echo ECS_CLUSTER=${aws_ecs_cluster.this.name} >> /etc/ecs/ecs.config
EOF
  )

  vpc_security_group_ids = [aws_security_group.ecs_instances.id]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "${var.project_name}-${var.environment}-ecs-node"
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}

############################################
# AUTO SCALING GROUP (SINGLE NODE)
############################################
resource "aws_autoscaling_group" "ecs" {
  desired_capacity    = 1
  min_size            = 1
  max_size            = 1
  vpc_zone_identifier = var.public_subnet_ids

  launch_template {
    id      = aws_launch_template.ecs.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-${var.environment}-ecs-asg"
    propagate_at_launch = true
  }
}

############################################
# CAPACITY PROVIDER (REQUIRED FOR EC2 ECS)
############################################
resource "aws_ecs_capacity_provider" "this" {
  name = "${var.project_name}-${var.environment}-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.ecs.arn
  }
}

resource "aws_ecs_cluster_capacity_providers" "this" {
  cluster_name = aws_ecs_cluster.this.name

  capacity_providers = [aws_ecs_capacity_provider.this.name]

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.this.name
    weight            = 1
  }
}

############################################
# CLOUDWATCH LOG GROUP
############################################
resource "aws_cloudwatch_log_group" "backend" {
  name              = "/ecs/${var.project_name}-${var.environment}-backend"
  retention_in_days = 7
}

############################################
# TASK DEFINITION
############################################
resource "aws_ecs_task_definition" "backend" {
  family                   = "${var.project_name}-${var.environment}-backend"
  requires_compatibilities = ["EC2"]
  network_mode             = "bridge"
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name      = "backend"
      image     = var.backend_image
      essential = true

      portMappings = [{
        containerPort = 5000
        hostPort      = 5000
      }]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.backend.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

############################################
# ECS SERVICE
############################################
resource "aws_ecs_service" "backend" {
  name            = "${var.project_name}-${var.environment}-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.backend.arn
  desired_count   = 1
  launch_type     = "EC2"

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "backend"
    container_port   = 5000
  }

  depends_on = [
    aws_ecs_cluster_capacity_providers.this
  ]
}



