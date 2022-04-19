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
