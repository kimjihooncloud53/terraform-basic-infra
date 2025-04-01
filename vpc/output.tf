output "public_subnet_ids" {
  value = [aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_b.id]
}

output "vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "private_subnet_ids" {
  value = [aws_subnet.private_subnet_a.id]
}