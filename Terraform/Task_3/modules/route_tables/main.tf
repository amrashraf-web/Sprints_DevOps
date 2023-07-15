resource "aws_route_table" "public_route_table" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.internet_gateway_id
  }

  tags = {
    Name = "Public-RT"
  }
}

resource "aws_route_table_association" "public_route_table_association" {
  for_each        = { for idx, subnet in var.pub_subnets : idx => subnet }
  subnet_id       = each.value
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table" "private_route_table" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = var.nat_gateway_id
  }

  tags = {
    Name = "Private-RT"
  }
}

resource "aws_route_table_association" "private_route_table_association" {
  for_each        = { for idx, subnet in var.pvt_subnets : idx => subnet }
  subnet_id       = each.value
  route_table_id = aws_route_table.private_route_table.id
}

