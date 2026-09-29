data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "k8s_master_node" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.private.id
  key_name      = var.key_name
  #security_groups = [aws_security_group.k8s_sg.name]
  vpc_security_group_ids = [aws_security_group.k8s_sg.id]
  iam_instance_profile = aws_iam_instance_profile.k8s_node.name
  associate_public_ip_address = false

  tags = {
    Name = "k8s-master-node"
  }
}

resource "aws_instance" "k8s_worker_node-1" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.private.id
  key_name      = var.key_name
#   security_groups = [aws_security_group.k8s_sg.name]
  vpc_security_group_ids = [aws_security_group.k8s_sg.id]
  iam_instance_profile = aws_iam_instance_profile.k8s_node.name
  associate_public_ip_address = false

  tags = {
    Name = "k8s-worker-node-1"
  }
}

resource "aws_key_pair" "k8s_key" {
  key_name   = var.key_name
  public_key = file(var.key_path)
  
}