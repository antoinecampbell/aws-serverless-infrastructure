resource "aws_api_gateway_rest_api" "note" {
  name = "note-api-${var.environment}"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
  tags = local.tags
}

resource "aws_api_gateway_usage_plan" "note" {
  name = "note-api-${var.environment}"
  api_stages {
    api_id = aws_api_gateway_rest_api.note.id
    stage = aws_api_gateway_stage.note.stage_name
  }
}

resource "aws_api_gateway_api_key" "note" {
  name = "note-api-key-${var.environment}"
}

resource "aws_api_gateway_usage_plan_key" "note" {
  key_id = aws_api_gateway_api_key.note.id
  key_type = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.note.id
}

resource "aws_ssm_parameter" "api_key" {
  name = "/notes-${var.environment}/api-key"
  type = "SecureString"
  value = aws_api_gateway_api_key.note.value
}

resource "aws_api_gateway_resource" "note" {
  rest_api_id = aws_api_gateway_rest_api.note.id
  parent_id = aws_api_gateway_rest_api.note.root_resource_id
  path_part = "notes"
}

resource "aws_api_gateway_stage" "note" {
  deployment_id = aws_api_gateway_deployment.note.id
  rest_api_id = aws_api_gateway_rest_api.note.id
  stage_name = var.environment

  tags = local.tags
}

resource "aws_api_gateway_deployment" "note" {
  rest_api_id = aws_api_gateway_rest_api.note.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.note,
      module.get_notes_lambda_rest.method,
      module.create_note_lambda_rest.method,
      module.get_notes_lambda_rest.integration,
      module.create_note_lambda_rest.integration
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

output "api_url" {
  value = aws_api_gateway_deployment.note.invoke_url
}

output "notes_endpoint" {
  value = "${aws_api_gateway_deployment.note.invoke_url}${aws_api_gateway_stage.note.stage_name}/${aws_api_gateway_resource.note.path_part}"
}

output "api_key" {
  value = aws_api_gateway_api_key.note.value
}

output "api_key_param_name" {
  value = aws_ssm_parameter.api_key.name
}