output "bastion_host_ip" {
  value = aws_instance.bastion_host.public_ip
}

output "private_host_ip" {
  value = aws_instance.private_host.private_ip
}