resource "aws_api_gateway_rest_api" "note" {
  name = "note-api-${var.environment}"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
  tags = local.tags
}

resource "aws_api_gateway_resource" "note" {
  rest_api_id = aws_api_gateway_rest_api.note.id
  parent_id = aws_api_gateway_rest_api.note.root_resource_id
  path_part = "notes"
}

resource "aws_api_gateway_deployment" "stage" {
  rest_api_id = aws_api_gateway_rest_api.note.id
  stage_name = var.environment

  depends_on = [
    module.get_notes_lambda_rest,
    module.create_note_lambda_rest
  ]

  variables = {
    timestamp = timestamp()
  }
}

output "api_url" {
  value = aws_api_gateway_deployment.stage.invoke_url
}
