output "vpc_id" {
  value = aws_vpc.this.id
}

output "subnet_id" {
  value = aws_subnet.public.id
}

output "subnet_id_2" {
  value = aws_subnet.public2.id
}

output "security_group_id" {
  value = aws_security_group.public.id
}

output "security_group_id_alb" {
  value = aws_security_group.alb.id
}
