output "route_table_id" {
  value = aws_route_table.route_table.*.id
}
output "route_table_arn" {
  value = aws_route_table.route_table.*.arn
}