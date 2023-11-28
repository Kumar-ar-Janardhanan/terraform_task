output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "my_eip"{
  value=aws_eip.my_eip.allocation_id
}