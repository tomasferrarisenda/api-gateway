resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
    }]
  })
}

resource "aws_lambda_function" "lambda_sum" {
  filename      = "./templates/lambda_sum.zip"
  function_name = "lambda_sum"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_sum.lambda_handler"
  runtime       = "python3.8"

  source_code_hash = filebase64sha256("./templates/lambda_sum.zip")
}

resource "aws_lambda_function" "hello_lambda" {
  filename         = "./templates/hello_lambda_function.zip"
  function_name    = "hello_lambda"
  role             = aws_iam_role.hello_lambda_role.arn
  handler          = "hello_lambda_function.lambda_handler"
  runtime          = "python3.8"

  source_code_hash = filebase64sha256("./templates/hello_lambda_function.zip")
}
# resource "aws_lambda_function" "lambda_hello_world" {
#   filename      = "./templates/lambda_hello_world.zip"
#   function_name = "lambda_hello_world"
#   role          = aws_iam_role.lambda_role.arn
# #   handler       = "lambda_function.lambda_handler"
#   runtime       = "python3.8"

#   source_code_hash = filebase64sha256("./templates/lambda_hello_world.zip")
# }