# resources
module "get_notes_lambda" {
  source = "./modules/lambda"

  function_name = "get-notes-${var.environment}"
  filename = var.zip_path
  handler = "src/index.getNotesHandler"
  runtime = "nodejs12.x"
  role = aws_iam_role.notes_lambda_dynamo.arn
  environment_variables = {
    TABLE_NAME = aws_dynamodb_table.notes.name
  }
  timeout = 5
  tags = local.tags
}

module "get_notes_lambda_rest" {
  source = "./modules/lambda-rest"

  rest_api_id = aws_api_gateway_rest_api.note.id
  rest_api_execution_arn = aws_api_gateway_rest_api.note.execution_arn
  resource_id = aws_api_gateway_resource.note.id
  http_method = "GET"
  lambda_arn = module.get_notes_lambda.function_arn
  lambda_invoke_arn = module.get_notes_lambda.invoke_arn
}

module "create_note_lambda" {
  source = "./modules/lambda"

  function_name = "create-notes-${var.environment}"
  filename = var.zip_path
  handler = "src/index.createNoteHandler"
  runtime = "nodejs12.x"
  role = aws_iam_role.notes_lambda_dynamo.arn
  environment_variables = {
    TABLE_NAME = aws_dynamodb_table.notes.name
  }
  timeout = 5
  tags = local.tags
}

module "create_note_lambda_rest" {
  source = "./modules/lambda-rest"

  rest_api_id = aws_api_gateway_rest_api.note.id
  rest_api_execution_arn = aws_api_gateway_rest_api.note.execution_arn
  resource_id = aws_api_gateway_resource.note.id
  http_method = "POST"
  lambda_arn = module.create_note_lambda.function_arn
  lambda_invoke_arn = module.create_note_lambda.invoke_arn
}

# outputs
output "get_notes_function_name" {
  value = module.get_notes_lambda.function_name
}

output "create_notes_function_name" {
  value = module.create_note_lambda.function_name
}
