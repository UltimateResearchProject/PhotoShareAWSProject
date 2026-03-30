resource "aws_lambda_function" "lambda" {
  function_name = "photoshare-lambda"

  runtime = "python3.12"
  handler = "lambda_handler.lambda_handler"

  filename = "lambda.zip"

  role = var.role_arn

  vpc_config {
    subnet_ids         = [var.subnet_id]
    security_group_ids = [var.sg_id]
  }
}