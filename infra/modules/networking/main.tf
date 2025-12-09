resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name  = "${var.environment}-vpc"
  }
} 


resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id 
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-west-2a"

  tags = {
    Name = "${var.environment}-private-subnet"
  }
}

resource "aws_subnet" "private-b" {
  vpc_id            = aws_vpc.main.id 
  cidr_block        = "10.0.3.0/24"
  availability_zone = "eu-west-2b"

  tags = {
    Name = "${var.environment}-private-subnet2"
  }
}
     


resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id


  tags = {
    Name = "${var.environment}-private-rt"
  }
}


resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}


resource "aws_route_table_association" "private-b" {
  subnet_id      = aws_subnet.private-b.id
  route_table_id = aws_route_table.private.id
}



