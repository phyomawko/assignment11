resource "aws_instance" "app_server" {
  ami           =  var.ami
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.application_subnet.id
  # key_name      = "pmk-own-labs"
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  

  tags = {
    Name = "Application-Server"
  }
}
