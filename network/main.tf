resource "aws_vpc" "labvpc" {
  cidr_block = var.vpc_scope
  tags = {
    Name = "${var.name}-vpc"
    terraform_stack = "network-${var.name}"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.labvpc.id
  cidr_block = var.subnet_scope
  tags = {
    Name = "${var.name}-public_subnet"
    terraform_stack = "network-${var.name}"
  }
}

resource "aws_internet_gateway" "gw" {
  // Not needed because of aws_internet_gateway_attachment below do the same
  //vpc_id = aws_vpc.labvpc.id

  tags = {
    Name = "${var.name}-IGW"
    terraform_stack = "network-${var.name}"
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
  vpc_id = aws_vpc.labvpc.id

  route {
    cidr_block = "0.0.0.0/24"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.name}-public_route_table"
    terraform_stack = "network-${var.name}"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_network_interface" "networkinterface" {
  subnet_id   = aws_subnet.public_subnet.id
  //private_ips = ["172.16.10.100"]

  tags = {
    Name = "primary_network_interface"
    terraform_stack = "network-${var.name}"
  }
}

resource "aws_instance" "web" {
  ami = "ami-0ff8a91507f77f867"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  /*network_interface {
    network_interface_id = aws_network_interface.networkinterface.id
    device_index         = 0
  }*/
  tags = {
    Name = "Web"
    terraform_stack = "network-${var.name}"
  }
}
