variable "rest_api_id" {}
variable "rest_api_execution_arn" {}
variable "resource_id" {}
variable "http_method" {}
variable "authorization" {
  default = "NONE"
}
variable "lambda_arn" {}
variable "lambda_invoke_arn" {}
variable "api_key_required" {}

resource "aws_api_gateway_method" "method" {
  rest_api_id = var.rest_api_id
  resource_id = var.resource_id
  http_method = var.http_method
  authorization = var.authorization
  api_key_required = var.api_key_required
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id = var.rest_api_id
  resource_id = var.resource_id
  http_method = aws_api_gateway_method.method.http_method

  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = var.lambda_invoke_arn
}

resource "aws_lambda_permission" "permission" {
  statement_id = "AllowAPIGatewayInvoke"
  action = "lambda:InvokeFunction"
  function_name = var.lambda_arn
  principal = "apigateway.amazonaws.com"
  source_arn = "${var.rest_api_execution_arn}/*/*"
}

output "integration" {
  value = aws_api_gateway_integration.integration
}

output "method" {
  value = aws_api_gateway_method.method
}

