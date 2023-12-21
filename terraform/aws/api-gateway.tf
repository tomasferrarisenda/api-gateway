resource "aws_api_gateway_rest_api" "my_api" {
  name        = "example-api"
  description = "Example API Gateway"
}

resource "aws_api_gateway_resource" "api_resource" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id   = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part   = "myresource"
}

resource "aws_api_gateway_method" "api_method" {
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  resource_id   = aws_api_gateway_resource.api_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.api_resource.id
  http_method = aws_api_gateway_method.api_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_sum.invoke_arn

  request_templates = {
    "application/json" = <<EOF
{
  "number1": $input.json('$.number1'),
  "number2": $input.json('$.number2')
}
EOF
  }



resource "aws_lambda_permission" "api_lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_sum.function_name
  principal     = "apigateway.amazonaws.com"

  # The source ARN for this permission should be the ARN of the API method.
  source_arn = "${aws_api_gateway_rest_api.my_api.execution_arn}/*/POST/myresource"
}

# Update API Gateway Deployment to trigger a new deployment
resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [
    aws_api_gateway_integration.lambda_integration,
    aws_api_gateway_integration.hello_lambda_integration
  ]

  rest_api_id = aws_api_gateway_rest_api.my_api.id
  stage_name  = "dev"

  # Forces a new deployment on configuration changes
  triggers = {
    redeployment = sha256(jsonencode(aws_api_gateway_rest_api.my_api.body))
  }
}



# New API Gateway Resource for 'hello' function
resource "aws_api_gateway_resource" "hello_api_resource" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id   = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part   = "hello"
}

# New API Gateway Method for 'hello' function
resource "aws_api_gateway_method" "hello_api_method" {
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  resource_id   = aws_api_gateway_resource.hello_api_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

# Lambda Permission for 'hello' function
resource "aws_lambda_permission" "hello_api_lambda_permission" {
  statement_id  = "AllowAPIGatewayInvokeHello"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hello_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.my_api.execution_arn}/*/GET/hello"
}

# API Gateway Integration for 'hello' function
resource "aws_api_gateway_integration" "hello_lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.hello_api_resource.id
  http_method = aws_api_gateway_method.hello_api_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.hello_lambda.invoke_arn
}



# Output for base URL remains the same
output "base_url" {
  value = "${aws_api_gateway_deployment.api_deployment.invoke_url}/"
}


# API Key resource
resource "aws_api_gateway_api_key" "my_api_key" {
  name = "my-api-key"
  description = "API Key for accessing my API"
  enabled = true
}

# Usage plan resource
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

# Associate API Key with the Usage Plan
resource "aws_api_gateway_usage_plan_key" "my_api_key_association" {
  key_id = aws_api_gateway_api_key.my_api_key.id
  key_type = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.my_api_usage_plan.id
}

# Output the API Key
output "api_key" {
    sensitive = true
  value = aws_api_gateway_api_key.my_api_key.value
}