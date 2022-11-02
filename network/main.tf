resource "aws_vpc" "labvpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subet" "public_subnet" {
    vpc_id = aws_vpc.labvpc.id
    cidr_block = "10.0.0.0/24"
    tags = {
        Name = "public_subnet"
    }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

resource "aws_internet_gateway_attachment" "gwattachment" {
  internet_gateway_id = aws_internet_gateway.gw.id
  vpc_id              = aws_vpc.labvpc.id
}

resource "aws_route_table" "public_route_table" {
    depends_on = [
      aws_internet_gateway_attachment.gwattachment
    ]
  vpc_id = aws_vpc.example.id

  route {
    cidr_block = "0.0.0.0/24"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public_route_table"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table
}
