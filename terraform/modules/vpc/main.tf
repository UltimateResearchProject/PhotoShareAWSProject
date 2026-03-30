resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.this.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_subnet" "private_app" {
  vpc_id     = aws_vpc.this.id
  cidr_block = "10.0.2.0/24"
}

resource "aws_subnet" "private_db" {
  vpc_id     = aws_vpc.this.id
  cidr_block = "10.0.3.0/24"
}