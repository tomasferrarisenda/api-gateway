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

# Use this for testing:
# {
#   "number1": 2,
#   "number2": 2
# }

# curl -X POST https://lkq5yijt31.execute-api.us-east-1.amazonaws.com/dev/myresource \
# -H "x-api-key: Vd2ykeBup43hK5UCwX2t38lRBe5rcVX73gYwjKKU" \
# -H "Content-Type: application/json" \
# -d '{"number1": 10, "number2": 5}'


resource "aws_lambda_function" "hello_lambda" {
  filename         = "./templates/hello_lambda_function.zip"
  function_name    = "hello_lambda"
  role             = aws_iam_role.lambda_role.arn
  handler          = "hello_lambda_function.lambda_handler"
  runtime          = "python3.8"

  source_code_hash = filebase64sha256("./templates/hello_lambda_function.zip")
}

# curl -X GET https://lkq5yijt31.execute-api.us-east-1.amazonaws.com/dev//hello \
# -H "x-api-key: Vd2ykeBup43hK5UCwX2t38lRBe5rcVX73gYwjKKU"
