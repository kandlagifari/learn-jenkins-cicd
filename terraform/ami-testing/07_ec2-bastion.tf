data "aws_ami" "jenkins-master" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["jenkins-master-*"]
  }
}

data "aws_ami" "jenkins-worker" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["jenkins-worker*"]
  }
}

resource "aws_security_group" "devops_sg" {
  name        = "devops_allow_egress_sg"
  description = "Only allow egress traffic for devops security group"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "devops_allow_egress_sg"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_for_devops" {
  security_group_id = aws_security_group.devops_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "allow_traffic_ipv4_for_jenkins" {
  security_group_id = aws_security_group.devops_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 8080
  ip_protocol = "tcp"
  to_port     = 8080
}

resource "aws_iam_role" "devops_role" {
  name = "devops-iam-role"

  assume_role_policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = [
      {
        "Action" = "sts:AssumeRole",
        "Effect" = "Allow",
        "Sid"    = "",
        "Principal" = {
          "Service" = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "AmazonSSMManagedInstanceCore" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.devops_role.name
}

resource "aws_iam_instance_profile" "devops_instance_profile" {
  name = "devops-instance-profile"
  role = aws_iam_role.devops_role.name
}

resource "aws_instance" "devops_ami" {
  for_each               = var.ec2
  ami                    = data.aws_ami.jenkins-worker.id #data.aws_ami.jenkins-master.id 
  instance_type          = each.value["instance_type"]
  iam_instance_profile   = aws_iam_instance_profile.devops_instance_profile.name
  vpc_security_group_ids = [aws_security_group.devops_sg.id]
  subnet_id              = aws_subnet.public_1.id
  key_name               = "EC2JakartaKey"

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = each.value["tags"]
}
