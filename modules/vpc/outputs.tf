output "region" {
  value = var.region
}

output "project_name" {
  value = var.project_name
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet1_id" {
  value = aws_subnet.public_subnet.id
}

output "private_app_subnet1_id" {
  value = aws_subnet.private_app_subnet1.id
}

output "private_app_subnet2_id" {
  value = aws_subnet.private_app_subnet2.id
}

output "private_data_subnet1_id" {
  value = aws_subnet.private_data_subnet1.id
}

output "private_data_subnet2_id" {
  value = aws_subnet.private_data_subnet2.id
}

output "internet_gateway" {
  value = aws_internet_gateway.internet_gateway
}