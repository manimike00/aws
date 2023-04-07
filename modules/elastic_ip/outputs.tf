output "elastic_ip" {
  value = aws_eip.eip.public_ip
}
output "elastic_private_ip" {
  value = aws_eip.eip.private_ip
}
output "elastic_id" {
  value = aws_eip.eip.id
}