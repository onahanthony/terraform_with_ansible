resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name" = "Application-1"
  }
}

resource "aws_subnet" "public-sb1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    "Name" = "Application-1-public-sb1"
  }
}

resource "aws_subnet" "public-sb2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    "Name" = "Application-1-public-sb2"
  }
}

resource "aws_subnet" "private-sb" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1c"
  tags = {
    "Name" = "Application-1-private-2c"
  }
}

resource "aws_route_table" "this-rt" {
  vpc_id = aws_vpc.main.id
  tags = {
    "Name" = "Application-1-route-table"
  }
}

resource "aws_route_table_association" "public-sb1" {
  subnet_id      = aws_subnet.public-sb1.id
  route_table_id = aws_route_table.this-rt.id
}
resource "aws_route_table_association" "public-sb2" {
  subnet_id      = aws_subnet.public-sb1.id
  route_table_id = aws_route_table.this-rt.id
}

resource "aws_internet_gateway" "this-igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    "Name" = "Application-1-gateway"
  }
}
resource "aws_route" "internet-route" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.this-rt.id
  gateway_id             = aws_internet_gateway.this-igw.id
}