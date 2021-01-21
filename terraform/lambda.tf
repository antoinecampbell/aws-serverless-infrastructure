# variables

# resources
module "get_notes_lambda" {
  source = "./modules/lambda"

  function_name = "get-notes-${var.environment}"
  filename = "../node-functions/notes/lambda.zip"
  handler = "src/index.getNotesHandler"
  runtime = "nodejs12.x"
  role = aws_iam_role.lambda_dynamo_vpc.arn
  environment_variables = {
    TABLE_NAME = aws_dynamodb_table.notes.name
  }
  tags = local.tags
}

# outputs
output "get_notes_function_name" {
  value = module.get_notes_lambda.function_name
}