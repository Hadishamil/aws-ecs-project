# Security Group for ALB
resource "aws_security_group" "alb_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "tcp"
    from_port   = 3000
    to_port     = 3000
    cidr_blocks = [aws_subnet.private.cidr_block]
  }

  tags = {
    Name = "alb-sg"
  }
}

# Security Group for ECS
resource "aws_security_group" "ecs_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = 3000
    to_port     = 3000
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    protocol    = "tcp"
    from_port   = 3306
    to_port     = 3306
    security_groups = [aws_security_group.rds_sg.id]
  }

  egress {
    protocol    = "tcp"
    from_port   = 6379
    to_port     = 6379
    security_groups = [aws_security_group.elasticache_sg.id]
  }

  tags = {
    Name = "ecs-sg"
  }
}

# Security Group for RDS
resource "aws_security_group" "rds_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = 3306
    to_port     = 3306
    security_groups = [aws_security_group.ecs_sg.id]
  }

  tags = {
    Name = "rds-sg"
  }
}

# Security Group for ElastiCache
resource "aws_security_group" "elasticache_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = 6379
    to_port     = 6379
    security_groups = [aws_security_group.ecs_sg.id]
  }

  tags = {
    Name = "elasticache-sg"
  }
}