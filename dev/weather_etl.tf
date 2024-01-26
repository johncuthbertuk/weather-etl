locals {
    output_zip = "weatheretl.zip"
}

data "archive_file" "python_lambda_etl_package" {  
  type = "zip"  
  source_file = "${path.module}/code/weather_etl.py" 
  output_path = "${local.output_zip}"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.func.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.weather_data.arn
}

resource "aws_lambda_function" "func" {
    function_name = "weatherETL"
    filename      = "${local.output_zip}"
    source_code_hash = data.archive_file.python_lambda_etl_package.output_base64sha256
    role          = aws_iam_role.iam_for_lambda.arn
    runtime       = "python3.6"
    handler       = "lambda_function.lambda_handler"
    timeout       = 10
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.weather_data.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.func.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "data/"
    filter_suffix       = ".csv"
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}