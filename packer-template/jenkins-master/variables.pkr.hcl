variable "aws_profile" {
  type    = string
  default = "default"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "ssh_key" {
  type    = string
  default = "/path/to/private-key"
}
