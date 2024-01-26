locals {
    output_weather_retrieve_zip = "weather_retrieve.zip"
}

data "archive_file" "python_lambda_retrieve_package" {  
  type = "zip"  
  source_file = "${path.module}/code/weather_retrieve.py" 
  output_path = "${local.output_weather_retrieve_zip}"
}

resource "aws_lambda_function" "retrieve" {
    function_name = "weatherRetrieve"
    filename      = "${local.output_weather_retrieve_zip}"
    source_code_hash = data.archive_file.python_lambda_retrieve_package.output_base64sha256
    role          = aws_iam_role.iam_for_lambda.arn
    runtime       = "python3.6"
    handler       = "lambda_function.lambda_handler"
    timeout       = 10
}
