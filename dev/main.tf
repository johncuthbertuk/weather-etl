resource "aws_cloudwatch_event_rule" "retrieve_weather_every_weekday" {
  name = "retrieve-weather-every-weekday-rule"
  description = "Every weeekday at 5am"
  schedule_expression = "cron(0 5 * * MON-FRI *)"
}

resource "aws_cloudwatch_event_target" "retrieve_weather_every_weekday_target" {
  arn = aws_lambda_function.retrieve.arn
  rule = aws_cloudwatch_event_rule.retrieve_weather_every_weekday.name
}

resource "aws_lambda_permission" "allow_retrieve_weather_every_weekday" {
  statement_id = "AllowExecutionFromCloudWatch"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.retrieve.function_name
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.retrieve_weather_every_weekday.arn
}
