resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "kube-vpc-project"
  }
}
output "vpc_cidr" {
  value = aws_vpc.main.cidr_block
}