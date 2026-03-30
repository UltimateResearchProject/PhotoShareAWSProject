resource "aws_instance" "web" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t3.micro"

  subnet_id = var.subnet_id

  vpc_security_group_ids = [var.sg_id]

  key_name = var.key_pair_name

  associate_public_ip_address = false
}

output "instance_id" {
  value = aws_instance.web.id
}