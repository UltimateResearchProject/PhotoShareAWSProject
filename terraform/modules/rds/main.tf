resource "aws_db_instance" "db" {
  engine         = "mysql"
  instance_class = "db.t3.micro"

  allocated_storage = 20
  db_subnet_group_name = var.db_subnet_group_name

  username = var.db_username
  password = var.db_password

  vpc_security_group_ids = [var.sg_id]

  skip_final_snapshot = true
}