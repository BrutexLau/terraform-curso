
resource "aws_instance" "public_instance" {
  ami           = "ami-0de716d6197524dd9"
  instance_type = "t3.micro"
  subnet_id = aws_subnet.public_subnet.id
  tags = {
    Name = "HelloWorld"
  }
}