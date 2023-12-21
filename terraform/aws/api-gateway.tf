# API Gateway
resource "aws_api_gateway_rest_api" "my_api" {
  name        = "${var.project}-api"
  description = "${var.project} API Gateway"
}

resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [
    aws_api_gateway_integration.sum_lambda_integration,
    aws_api_gateway_integration.hello_lambda_integration
  ]

  rest_api_id = aws_api_gateway_rest_api.my_api.id
  stage_name  = "dev"

  triggers = {
    redeployment = sha256(jsonencode(aws_api_gateway_rest_api.my_api.body))
  }
}

output "base_url" {
  value = "${aws_api_gateway_deployment.api_deployment.invoke_url}/"
}


# Sum
resource "aws_api_gateway_resource" "sum_api_resource" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id   = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part   = "myresource"
}

resource "aws_api_gateway_method" "sum_api_method" {
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  resource_id   = aws_api_gateway_resource.sum_api_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_lambda_permission" "api_lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_sum.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.my_api.execution_arn}/*/POST/myresource"
}

resource "aws_api_gateway_integration" "sum_lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.sum_api_resource.id
  http_method = aws_api_gateway_method.sum_api_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_sum.invoke_arn
}


#Hello
resource "aws_api_gateway_resource" "hello_api_resource" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id   = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part   = "hello"
}

resource "aws_api_gateway_method" "hello_api_method" {
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  resource_id   = aws_api_gateway_resource.hello_api_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_lambda_permission" "hello_api_lambda_permission" {
  statement_id  = "AllowAPIGatewayInvokeHello"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_hello.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.my_api.execution_arn}/*/GET/hello"
}

resource "aws_api_gateway_integration" "hello_lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.hello_api_resource.id
  http_method = aws_api_gateway_method.hello_api_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_hello.invoke_arn
}




# API Key 
resource "aws_api_gateway_api_key" "my_api_key" {
  name = "my-api-key"
  description = "API Key for accessing my API"
  enabled = true
}

resource "aws_api_gateway_usage_plan" "my_api_usage_plan" {
  name = "my-usage-plan"
  description = "Usage plan for my API"

  api_stages {
    api_id = aws_api_gateway_rest_api.my_api.id
    stage = aws_api_gateway_deployment.api_deployment.stage_name
  }

  # Define quotas and throttling as needed
  # quota {
  #   limit = 1000
  #   period = "DAY"
  # }
  # throttle {
  #   burst_limit = 20
  #   rate_limit = 10
  # }
}

resource "aws_api_gateway_usage_plan_key" "my_api_key_association" {
  key_id = aws_api_gateway_api_key.my_api_key.id
  key_type = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.my_api_usage_plan.id
}

output "api_key" {
    sensitive = true
  value = aws_api_gateway_api_key.my_api_key.value
}