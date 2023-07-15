resource "aws_internet_gateway" "sprints_igw" {
  vpc_id = var.vpc_id
  tags = {
    Name = "Sprints-IGW"
  }
}
