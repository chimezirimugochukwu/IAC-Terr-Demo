# allocate elastic ip. this eip will be used for the nat-gateway in public subnet 1 
resource "aws_eip" "eip_for_nat_gateway_1" {
  vpc    = true

  tags   = {
    Name = " Nat gateway EIP 1"
  }
}

# allocate elastic ip. this eip will be used for the nat-gateway in public subnet 2
resource "aws_eip" "eip_for_nat_gateway_2" {
  vpc    = true

  tags   = {
    Name = " Nat gateway EIP 2"
  }
}



# create nat gateway in public subnet 1
resource "aws_nat_gateway" "nat_gateway_1" {
  allocation_id = aws_eip.eip_for_nat_gateway_1.id
  subnet_id     = var.public_subnet1_id

  tags   = {
    Name = "nat  gateway 1"
  }

  # to ensure proper ordering, it is recommended to add an explicit dependency
  depends_on = [var.internet_gateway]
}

# create nat gateway in public subnet 2
resource "aws_nat_gateway" "nat_gateway_2" {
  allocation_id = aws_eip.eip_for_nat_gateway_2.id
  subnet_id     = var.public_subnet2_id

  tags   = {
    Name = "nat  gateway 2"
  }

  # to ensure proper ordering, it is recommended to add an explicit dependency
  depends_on = [var.internet_gateway]
}


# create private route table az1 and add route through nat gateway az1
resource "aws_route_table" "private_route_table_az1" {
  vpc_id            = var.vpc_id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.nat_gateway_1.id
  }

  tags   = {
    Name = "Private route table az1"
  }
}

# associate private app subnet az1 with private route table az1
resource "aws_route_table_association" "private_app_subnet_az1_route_table_az1_association" {
  subnet_id         = var.private_app_subnet1_id
  route_table_id    = aws_route_table.private_route_table_az1.id
}

# associate private data subnet az1 with private route table az1
resource "aws_route_table_association" "private_data_subnet_az1_route_table_az1_association" {
  subnet_id         = var.private_data_subnet1_id
  route_table_id    = aws_route_table.private_route_table_az1.id
}

# create private route table az2 and add route through nat gateway az2
resource "aws_route_table" "private_route_table_az2" {
  vpc_id            = var.vpc_id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.nat_gateway_2.id
  }

  tags   = {
    Name = "Private route table az2"
  }
}

# associate private app subnet az2 with private route table az2
resource "aws_route_table_association" "private_app_subnet_az2_route_table_az2_association" {
  subnet_id         = var.private_app_subnet2_id
  route_table_id    = aws_route_table.private_route_table_az2.id
}

# associate private data subnet az2 with private route table az2
resource "aws_route_table_association" "private_data_subnet_az2_route_table_az2_association" {
  subnet_id         = var.private_data_subnet2_id
  route_table_id    = aws_route_table.private_route_table_az2.id
}