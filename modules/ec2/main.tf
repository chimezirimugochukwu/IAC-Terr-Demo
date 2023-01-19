# use data source to get a registered amazon linux 2 ami
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

# use data source to get details from parameter store
data "aws_key_pair" "key" {
  key_name = "nausicaa_key"
  include_public_key = false  

  filter {
    name = "tag:component"
    values = ["grants"]
  } 
}
  

#launch the bastion host
resource "aws_instance" "bastion_host" {
  ami = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"
  subnet_id = var.public_subnet1
  vpc_security_group_ids = [var.bastion_host_security_group]      
  key_name = data.aws_key_pair.key.key_name 
  
  tags = {
    Name = " Bastion Host server"
  }
}

#launch the private ec2 host
resource "aws_instance" "private_host" {
  ami = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"
  subnet_id = var.private_subnet1
  vpc_security_group_ids = [var.private_ec2_security_group]      
  key_name = data.aws_key_pair.key.key_name 
  
  tags = {
    Name = " Private Ec2 Host server"
  }
}