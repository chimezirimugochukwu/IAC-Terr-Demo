# create security group for the application load balancer
resource "aws_security_group" "alb_security_group" {
  name        = "alb security group"
  description = "enable http/https access on port 80/443"
  vpc_id      = var.vpc_id

  ingress {
    description      = "http access"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "https access"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "ALB security group"
  }
}

# create security group for the container
resource "aws_security_group" "ecs_security_group" {
  name        = "ecs security group"
  description = "enable http/https access on port 80/443 via alb sg"
  vpc_id      = var.vpc_id

  ingress {
    description      = "http access"
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    security_groups  = [aws_security_group.alb_security_group.id]
  }

  ingress {
    description      = "https access"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    security_groups  = [aws_security_group.alb_security_group.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "ECS security group"
  }
}

# create security group for the bastion host
resource "aws_security_group" "bastion_host_security_group" {
  name        = "bastion security group"
  description = "enable ssh access"
  vpc_id      = var.vpc_id

  ingress {
    description      = "ssh access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
  tags   = {
    Name = "Bastion host security group"
  }
}

# create security group for the private ec2
resource "aws_security_group" "private_ec2_security_group" {
  name        = "private_ec2 security group"
  description = "enable ssh access on port 22 via bastion host sg"
  vpc_id      = var.vpc_id

  ingress {
    description      = "ssh access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups  = [aws_security_group.bastion_host_security_group.id]
  }

  ingress {
    description      = "ping access"
    from_port        = -1
    to_port          = -1
    protocol         = "icmp"
    security_groups  = [aws_security_group.bastion_host_security_group.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "Private Ec2 security group"
  }
}

# create security group for the database
resource "aws_security_group" "database_security_group" {
  name        = "database security group"
  description = "enable access on port 8000 via private ec2 sg"
  vpc_id      = var.vpc_id

  ingress {
    description      = "http access"
    from_port        = 8000
    to_port          = 8000
    protocol         = "tcp"
    security_groups  = [aws_security_group.private_ec2_security_group.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
  tags   = {
    Name = "Database security group"
  }
}