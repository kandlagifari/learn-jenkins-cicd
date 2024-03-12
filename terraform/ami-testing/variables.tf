variable "aws_profile" {
  description = "AWS Profile for Terraform"
  type        = string
}

variable "ec2" {
  type = map(object({
    instance_type = string
    tags          = map(string)
  }))
}