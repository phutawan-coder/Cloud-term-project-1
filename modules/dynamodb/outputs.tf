output "table-name" {
  value = aws_dynamodb_table.metadata_table.name
}

output "table-arn" {
   value = aws_dynamodb_table.metadata_table.arn
}
