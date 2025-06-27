# ElastiCache Subnet Group
resource "aws_elasticache_subnet_group" "cache_subnet" {
  name       = "cache-subnet-group"
  subnet_ids = [aws_subnet.private.id]

  tags = {
    Name = "cache-subnet-group"
  }
}

# ElastiCache Cluster
resource "aws_elasticache_cluster" "cache" {
  cluster_id           = "app-cache"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis5.0"
  engine_version       = "5.0.6"
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.cache_subnet.name
  security_group_ids   = [aws_security_group.elasticache_sg.id]

  tags = {
    Name = "app-cache"
  }
}