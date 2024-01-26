provider "aws" {
  region = "eu-west-2"

  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
}

provider "archive" {

}

terraform {
  # TODO: Configure backend state with S3 and DynamoDB
}