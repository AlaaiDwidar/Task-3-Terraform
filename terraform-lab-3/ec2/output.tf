output "ec2_public_ip" {
  description = "the public ip address of ec2 instance"
  value       = aws_instance.my_vm.public_ip
}
output "vmid1" {
  value = aws_instance.my_vm.id
}
output "vmid2" {
  value = aws_instance.my_vm2.id
}
output "vmid3" {
  value = aws_instance.my_vm3.id
}
output "vmid4" {
  value = aws_instance.my_vm4.id
}
output "protocol" {
  value       = "tcp"
}
output "port80" {
  value       = 80
}
output "public_cidr" {
  value       = "0.0.0.0/0"
}