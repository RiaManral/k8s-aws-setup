resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  #only creates the rt
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "k8s-public-rt"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.k8s_nat_gateway.id
  }
  tags = {
    Name = "k8s-private-rt"
  }
}


# Attach the route table to the public subnet
resource "aws_route_table_association" "k8s_public_rt_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}


# Attach the route table to the private subnet
resource "aws_route_table_association" "k8s_private_rt_assoc" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}


