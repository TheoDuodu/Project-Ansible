#creating AWS network for a project

resource "aws_vpc" "Prod-rock-VPC" {
  cidr_block           = var.vpc-cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "Prod-rock-VPC"
  }
}

#creating public subnet1

resource "aws_subnet" "Test-public-sub1" {
  vpc_id            = aws_vpc.Prod-rock-VPC.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.az

  tags = {
    Name = "Test-public -sub1"
  }
}

#creating public subnet2

resource "aws_subnet" "Test-public-sub2" {
  vpc_id            = aws_vpc.Prod-rock-VPC.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = var.az

  tags = {
    Name = "Test-public -sub2"
  }
}

#creating private subnet1

resource "aws_subnet" "Test-priv-sub1" {
  vpc_id            = aws_vpc.Prod-rock-VPC.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = var.az

  tags = {
    Name = "Test-priv-sub1"
  }
}

#creating private subnet2

resource "aws_subnet" "Test-priv-sub2" {
  vpc_id            = aws_vpc.Prod-rock-VPC.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = var.az

  tags = {
    Name = "Test-priv-sub2"
  }
}

#creating a public route table

resource "aws_route_table" "Test-pub-route-table" {
  vpc_id = aws_vpc.Prod-rock-VPC.id

  tags = {
    Name = "Test-pub-route-table"
  }
}

#creating a private route table

resource "aws_route_table" "Test-priv-route-table" {
  vpc_id = aws_vpc.Prod-rock-VPC.id

  tags = {
    Name = "Test-priv-route-table"
  }
}

#Associate  public subnet1 to public route table

resource "aws_route_table_association" "Prod-public-assoc1" {
  subnet_id      = aws_subnet.Test-public-sub1.id
  route_table_id = aws_route_table.Test-pub-route-table.id
}


#Associate  public subnet2 to public route table

resource "aws_route_table_association" "Prod-public-assoc2" {
  subnet_id      = aws_subnet.Test-public-sub2.id
  route_table_id = aws_route_table.Test-pub-route-table.id
}

#Associate  private subnet1 to private route table

resource "aws_route_table_association" "Prod-priv-assoc1" {
  subnet_id      = aws_subnet.Test-priv-sub1.id
  route_table_id = aws_route_table.Test-priv-route-table.id
}

#Associate  private subnet2 to private route table

resource "aws_route_table_association" "Prod-priv-assoc2" {
  subnet_id      = aws_subnet.Test-priv-sub2.id
  route_table_id = aws_route_table.Test-priv-route-table.id
}

#creating internet gateway
resource "aws_internet_gateway" "Test-igw" {
  vpc_id = aws_vpc.Prod-rock-VPC.id

  tags = {
    Name = "Test-igw"
  }
}

#associate internet gateway to public route table

resource "aws_route" "Test-igw-association" {
  route_table_id         = aws_route_table.Test-pub-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.Test-igw.id
}

#creating Elastic IP

resource "aws_eip" "Prod-EIP" {
  vpc = true
}

#creating NAT gateway

resource "aws_nat_gateway" "Test-Nat-gateway" {
  allocation_id = aws_eip.Prod-EIP.id
  subnet_id     = aws_subnet.Test-public-sub1.id

  tags = {
    Name = "Test-Nat-gateway"
  }
}

#Associating NATgateway with private route table

resource "aws_route" "test-Nat-association" {
  route_table_id         = aws_route_table.Test-priv-route-table.id
  nat_gateway_id         = aws_nat_gateway.Test-Nat-gateway.id
  destination_cidr_block = "0.0.0.0/0"
}
