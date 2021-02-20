# resources
resource "aws_cloudwatch_dashboard" "serverless_dashboard" {
  dashboard_name = "serverless-dashboard-${var.environment}"
  dashboard_body = templatefile("${path.module}/dashboards/serverless-dashboard-template.json",
  {
    region: var.region
    notes_table_name : aws_dynamodb_table.notes.name
    get_notes_function_name: module.get_notes_lambda.function_name
    create_note_function_name: module.create_note_lambda.function_name
  })
}
