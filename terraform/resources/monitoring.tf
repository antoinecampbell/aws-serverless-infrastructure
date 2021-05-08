variable "notes_table_alarm_evaluation_periods" {
  default = 1
}
variable "notes_table_alarm_threshold" {
  default = 5
}

# resources
resource "aws_cloudwatch_dashboard" "serverless_dashboard" {
  dashboard_name = "serverless-dashboard-${var.environment}"
  dashboard_body = templatefile("${path.module}/dashboards/serverless-dashboard-template.json",
  {
    region: var.region
    notes_table_name : aws_dynamodb_table.notes.name
    get_notes_function_name: module.get_notes_lambda.function_name
    create_note_function_name: module.create_note_lambda.function_name
    notes_table_write_alarm_arn: aws_cloudwatch_metric_alarm.notes_table_write.arn
    create_note_lambda_error_alarm_arn: aws_cloudwatch_metric_alarm.create_note_lambda_error.arn
    get_notes_lambda_error_alarm_arn: aws_cloudwatch_metric_alarm.get_notes_lambda_error.arn
    notes_api_5xx_error_alarm_arn: aws_cloudwatch_metric_alarm.notes_api_5xx_error.arn
    notes_api_4xx_error_alarm_arn: aws_cloudwatch_metric_alarm.notes_api_4xx_error.arn
    notes_api_name: aws_api_gateway_rest_api.note.name
  })
}

resource "aws_cloudwatch_metric_alarm" "notes_table_write" {
  alarm_name = "notes-table-write-alarm-${var.environment}"
  namespace = "AWS/DynamoDB"
  metric_name = "ConsumedWriteCapacityUnits"
  statistic = "Sum"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = 1
  threshold = 5
  period = 60
  dimensions = {
    TableName: aws_dynamodb_table.notes.name
  }
}

resource "aws_cloudwatch_metric_alarm" "create_note_lambda_error" {
  alarm_name = "create-note-lambda-alarm-${var.environment}"
  namespace = "AWS/Lambda"
  metric_name = "Errors"
  statistic = "Sum"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = 1
  threshold = 5
  period = 60
  dimensions = {
    FunctionName: module.create_note_lambda.function_name
  }
}

resource "aws_cloudwatch_metric_alarm" "get_notes_lambda_error" {
  alarm_name = "get-notes-lambda-alarm-${var.environment}"
  namespace = "AWS/Lambda"
  metric_name = "Errors"
  statistic = "Sum"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = 1
  threshold = 5
  period = 60
  dimensions = {
    FunctionName: module.get_notes_lambda.function_name
  }
}

resource "aws_cloudwatch_metric_alarm" "notes_api_5xx_error" {
  alarm_name = "notes-api-5xx-error-alarm-${var.environment}"
  namespace = "AWS/ApiGateway"
  metric_name = "5XXError"
  statistic = "Sum"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = 1
  threshold = 5
  period = 60
  dimensions = {
    ApiName: aws_api_gateway_rest_api.note.name
  }
}

resource "aws_cloudwatch_metric_alarm" "notes_api_4xx_error" {
  alarm_name = "notes-api-4xx-error-alarm-${var.environment}"
  namespace = "AWS/ApiGateway"
  metric_name = "4XXError"
  statistic = "Sum"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = 1
  threshold = 5
  period = 60
  dimensions = {
    ApiName: aws_api_gateway_rest_api.note.name
  }
}