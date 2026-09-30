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
  vpc_security_group_ids      = [aws_security_group.k8s_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.k8s_node.name
  associate_public_ip_address = false

  tags = {
    Name    = "k8s-master-node"
    Project = "k8s"
    Role    = "master"
  }
}

# output "current_state" {
#   value = aws_instance.k8s_worker_node-1.instance_state
# }

resource "aws_instance" "k8s_worker_node-1" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.private.id
  key_name      = var.key_name
  #   security_groups = [aws_security_group.k8s_sg.name]
  vpc_security_group_ids      = [aws_security_group.k8s_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.k8s_node.name
  associate_public_ip_address = false



  tags = {
    Name    = "k8s-worker-node-1"
    Project = "k8s"
    Role    = "worker"
  }
}

resource "aws_ec2_instance_state" "k8s_worker_node-1_state" {
  instance_id = aws_instance.k8s_worker_node-1.id
  state       = "running"
}
resource "aws_key_pair" "k8s_key" {
  key_name   = var.key_name
  public_key = file(var.key_path)

}

resource "aws_iam_role_policy" "ssm_s3_access" {
  name = "k8s-ssm-s3-access"
  role = aws_iam_role.k8s_node.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:GetEncryptionConfiguration"
        ]
        Resource = "arn:aws:s3:::ansible-ssm-bkt/*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = "arn:aws:s3:::ansible-ssm-bkt"
      }
    ]
  })
}