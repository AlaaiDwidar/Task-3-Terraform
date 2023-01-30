output "vpc_id" {
  value = aws_vpc.main.id
}
output "subnet1_id" {
  value = aws_subnet.web.id
}
output "subnet2_id" {
  value = aws_subnet.web2.id
}
output "subnet3_id" {
  value = aws_subnet.web3.id
}
output "subnet4_id" {
  value = aws_subnet.web4.id
}
