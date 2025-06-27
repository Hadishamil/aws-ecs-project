# RDS Instance
resource "aws_db_instance" "rds" {
  engine            = "mysql"
  instance_class    = "db.t2.micro"
  allocated_storage = 20
  storage_type      = "gp2"
  db_name           = "crud_db"
  username          = "admin" # Replace with your DB user
  password          = "password" # Replace with your DB password
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot = true
  publicly_accessible = false
  db_subnet_group_name = aws_db_subnet_group.rds_subnet.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  tags = {
    Name = "app-rds"
  }
}

# RDS Subnet Group
resource "aws_db_subnet_group" "rds_subnet" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.private.id]

  tags = {
    Name = "rds-subnet-group"
  }
}