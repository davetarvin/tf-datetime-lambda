terraform {
  required_version = "~> 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "random_pet" "lambda_bucket_name" {
  prefix = "datetime-lambda"
  length = 4
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = random_pet.lambda_bucket_name.id
  force_destroy = true
}

resource "aws_s3_bucket_acl" "lambda_bucket_acl" {
  bucket = random_pet.lambda_bucket_name.id
  acl = "private"
}

data "archive_file" "datetime_lambda" {
  type = "zip"

  source_dir  = "${path.module}/lambda"
  output_path = "${path.module}/datetime-lambda.zip"
}

resource "aws_s3_object" "datetime_lambda" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "datetime-lambda.zip"
  source = data.archive_file.datetime_lambda.output_path

  etag = filemd5(data.archive_file.datetime_lambda.output_path)
}

resource "aws_lambda_function" "datetime" {
  function_name = "DateTime"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.datetime_lambda.key

  runtime = "nodejs14.x"
  handler = "index.handler"

  source_code_hash = data.archive_file.datetime_lambda.output_base64sha256

  role = aws_iam_role.lambda_exec.arn
}

resource "aws_cloudwatch_log_group" "datetime_lambda_log_group" {
  name = "/aws/lambda/${aws_lambda_function.datetime.function_name}"

  retention_in_days = 1
}

resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
