# Trust policy: allow EC2 to assume this role
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# IAM role
resource "aws_iam_role" "k8s_node" {
  name               = "k8s-node-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = {
    Name = "k8s-node-role"
  }
}

# Attach the AWS managed SSM policy to the role
resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.k8s_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Instance profile (the wrapper EC2 uses to get the role)
resource "aws_iam_instance_profile" "k8s_node" {
  name = "k8s-node-profile"
  role = aws_iam_role.k8s_node.name
}