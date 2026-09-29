resource "aws_security_group" "k8s_sg" {
  name        = "k8s-node-sg"
  description = "Security group for Kubernetes cluster"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "k8s-nodes-sg"
  }
}



resource "aws_vpc_security_group_ingress_rule" "self_all" {
  security_group_id            = aws_security_group.k8s_sg.id
  referenced_security_group_id = aws_security_group.k8s_sg.id
  ip_protocol                  = "-1"
  description                  = "traffic from resources which have this security group attached"
}

resource "aws_vpc_security_group_egress_rule" "all_out" {
  security_group_id = aws_security_group.k8s_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}