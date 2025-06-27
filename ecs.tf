# Target Group for ECS
resource "aws_lb_target_group" "ecs_tg" {
  name     = "ecs-target-group"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path = "/"
    protocol = "HTTP"
    matcher = "200"
    interval = 30
    timeout = 5
    healthy_threshold = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "ecs-tg"
  }
}


# ECS Cluster
resource "aws_ecs_cluster" "cluster" {
  name = "app-cluster"

  tags = {
    Name = "app-cluster"
  }
}

# ECS Task Definition (simplified)
resource "aws_ecs_task_definition" "app" {
  family                   = "app-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name  = "app"
      image = "amazon/amazon-ecs-sample" # Replace with your ECR image
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
      environment = [
        { name = "DB_HOST", value = aws_db_instance.rds.address },
        { name = "DB_USER", value = "admin" }, # Replace with your DB user
        { name = "DB_PASSWORD", value = "password" } # Replace with your DB password
      ]
    }
  ])

  tags = {
    Name = "app-task"
  }
}

# ECS Service
resource "aws_ecs_service" "service" {
  name            = "app-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [aws_subnet.private.id]
    security_groups = [aws_security_group.ecs_sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tg.arn
    container_name   = "app"
    container_port  = 3000
  }

  tags = {
    Name = "app-service"
  }
}
