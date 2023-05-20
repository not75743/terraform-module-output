resource "aws_security_group" "ec2_sg" {
  name   = "ec2_sg"
  vpc_id = var.vpcid

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2_sg"
  }
}

resource "aws_iam_instance_profile" "test_instance_profile" {
  name = "test-instance-profile"
  role = var.role_name
}

resource "aws_instance" "test_instance" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet
  associate_public_ip_address = true

  security_groups      = [aws_security_group.ec2_sg.id]
  iam_instance_profile = aws_iam_instance_profile.test_instance_profile.name

  tags = {
    Name = "test-ec2"
  }
}
