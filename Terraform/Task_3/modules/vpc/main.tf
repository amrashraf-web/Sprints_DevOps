resource "aws_vpc" "sprints_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Sprints_VPC"
  }
}