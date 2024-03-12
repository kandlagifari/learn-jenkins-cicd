resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "192.168.0.0/18"
  availability_zone       = "ap-southeast-3a"
  map_public_ip_on_launch = true
  tags = {
    Name = "devops-public-ap-southeast-3a"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "192.168.64.0/18"
  availability_zone       = "ap-southeast-3b"
  map_public_ip_on_launch = true
  tags = {
    Name = "devops-public-ap-southeast-3b"
  }
}

resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "192.168.128.0/18"
  availability_zone = "ap-southeast-3a"
  tags = {
    Name = "devops-private-ap-southeast-3a"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "192.168.192.0/18"
  availability_zone = "ap-southeast-3b"
  tags = {
    Name = "devops-private-ap-southeast-3b"
  }
}
