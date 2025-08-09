# This will create the database subnet group where rds wil be created together with the standby
resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = var.db_subnet_ids

  tags = {
    Name        = "My DB subnet group"
    Environment = var.env
    Project     = var.project_name
  }
}


resource "aws_db_instance" "default" {
  allocated_storage         = 10
  db_name                   = var.db_name
  engine                    = var.db_engine
  engine_version            = var.db_engine_version
  instance_class            = var.db_instance_class
  username                  = var.db_username
  password                  = var.db_password
  parameter_group_name      = "default.postgres17"
  skip_final_snapshot       = true
  db_subnet_group_name      = aws_db_subnet_group.default.name
  delete_automated_backups  = true
  deletion_protection       = false
  vpc_security_group_ids    = [var.db_security_group]


  tags = {
    Name        = "My DB instance"
    Environment = var.env
    Project     = var.project_name
  }
}

