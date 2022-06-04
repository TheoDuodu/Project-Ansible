#creating a server for eu-west-2 region in the public subnet
resource "aws_instance" "Test-server1" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = "killmove"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.Test-sec-group.id]
  subnet_id                   = aws_subnet.Test-public-sub1.id
  availability_zone           = var.az

  tags = {
    Name = "Test-server1"
  }
}


#creating a server for eu-west-2 region in the private subnet

resource "aws_instance" "Test-server2" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = "Theo"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.Test-sec-group.id]
  subnet_id                   = aws_subnet.Test-priv-sub1.id
  availability_zone           = var.az

  tags = {
    Name = "Test-server2"
  }
}