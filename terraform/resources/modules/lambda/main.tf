# variables
variable "function_name" {}
variable "handler" {}
variable "role" {}
variable "runtime" {}
variable "filename" {}
variable "memory_size" {
  type = number
  default = 128
}
variable "timeout" {
  default = 15
}
variable "log_group_retention_in_days" {
  default = 3
}
variable "environment_variables" {
  type = map(string)
}
variable "reserved_concurrent_executions" {
  default = -1
}
variable "tags" {
  type = map(string)
}

# resources
resource "aws_lambda_function" "lambda" {
  function_name = var.function_name
  handler = var.handler
  role = var.role
  runtime = var.runtime
  filename = var.filename
  source_code_hash = filebase64sha256(var.filename)
  memory_size = var.memory_size
  timeout = var.timeout
  environment {
    variables = var.environment_variables
  }
  reserved_concurrent_executions = var.reserved_concurrent_executions
  tags = var.tags
}

resource "aws_cloudwatch_log_group" "log" {
  name = "/aws/lambda/${aws_lambda_function.lambda.function_name}"
  retention_in_days = var.log_group_retention_in_days
  tags = var.tags

}

# outputs
output "function_arn" {
  value = aws_lambda_function.lambda.arn
}

output "invoke_arn" {
  value = aws_lambda_function.lambda.invoke_arn
}

output "function_name" {
  value = var.function_name
}