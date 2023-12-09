resource "aws_iam_instance_profile" "profile" {
  name = var.name
  role = aws_iam_role.role.name
}

resource "aws_iam_role" "role" {
  name        = var.name
  description = "iam role for ${var.name} instance profile"
  tags = {
    Name = var.name
  }
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Principal": {"Service": "ec2.amazonaws.com"},
    "Action": "sts:AssumeRole"
  }
}
EOF
}

resource "aws_iam_role_policy_attachment" "role_attachment" {
  role       = aws_iam_role.role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
