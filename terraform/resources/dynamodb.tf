# resources
resource "aws_dynamodb_table" "notes" {
  name = "notes-${var.environment}"
  hash_key = "pk"
  range_key = "sk"
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = "pk"
    type = "S"
  }
  attribute {
    name = "sk"
    type = "S"
  }
  tags = local.tags
}

# outputs
output "notes_table_name" {
  value = aws_dynamodb_table.notes.name
}
