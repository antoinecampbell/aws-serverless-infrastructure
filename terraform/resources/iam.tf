# resources
data "aws_iam_policy_document" "lambda_service_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "notes_lambda_dynamo" {
  name = "notes-lambda-dynamodb-role-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.lambda_service_role.json
  tags = local.tags
}

data "aws_iam_policy_document" "notes_table" {
  statement {
    actions = [
      "dynamodb:GetItem",
      "dynamodb:BatchGetItem",
      "dynamodb:Query",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
      "dynamodb:DeleteItem",
      "dynamodb:BatchWriteItem"
    ]
    resources = [aws_dynamodb_table.notes.arn]
    effect = "Allow"
  }
}

resource "aws_iam_policy" "notes_table" {
  name = "notes-dynamodb-table-${var.environment}"
  policy = data.aws_iam_policy_document.notes_table.json
}

resource "aws_iam_role_policy_attachment" "vpc_lambda" {
  role = aws_iam_role.notes_lambda_dynamo.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "notes_table_dynamodb" {
  role = aws_iam_role.notes_lambda_dynamo.name
  policy_arn = aws_iam_policy.notes_table.arn
}