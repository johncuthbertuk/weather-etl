resource "aws_s3_bucket" "weather_data" {
  bucket = "weather-raw-data-20240126"
}

resource "aws_s3_bucket" "weather_transformed" {
  bucket = "weather-transformed-data-20240126"
}