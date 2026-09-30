resource "aws_eip" "k8s_nat_eip" {
  domain = "vpc"
  tags = {
    Name = "nat-gateway-eip"
  }
}


resource "aws_nat_gateway" "k8s_nat_gateway" {
  allocation_id = aws_eip.k8s_nat_eip.id
  subnet_id     = aws_subnet.public.id
  depends_on    = [aws_internet_gateway.igw]
}